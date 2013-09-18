Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3IRRRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:17:36 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63416 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3IRRRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:17:33 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: t.figa@samsung.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-samsung-soc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de, s.nawrocki@samsung.com
Subject: Re: [PATCH v2] serial: samsung: add support for manual RTS setting
Date: Wed, 18 Sep 2013 19:17:30 +0200
Message-ID: <1396773.mUrBgMlKxN@flatron>
User-Agent: KMail/4.11.1 (Linux/3.10.10-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1379519569-7266-1-git-send-email-jose.goncalves@inov.pt>
References: <1379519569-7266-1-git-send-email-jose.goncalves@inov.pt>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi José,

On Wednesday 18 of September 2013 16:52:49 José Miguel Gonçalves wrote:
> The Samsung serial driver currently does not support setting the
> RTS pin with an ioctl(TIOCMSET) call. This patch adds this support.
> 
> Changes in v2:
>  - Preserve the RTS pin's manual setting  in set_termios() also when
>    enabling CRTSCTS.
> 
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> ---
>  drivers/tty/serial/samsung.c |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

Looks good.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

