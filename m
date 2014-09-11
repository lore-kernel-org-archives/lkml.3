Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaIKLZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:25:36 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33018 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753524AbaIKLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:25:33 -0400
Message-ID: <541186A9.902@hurleysoftware.com>
Date: Thu, 11 Sep 2014 07:25:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3.17-rc3] serial: amba-pl011: Use container_of() to get
 uart_amba_port
References: <1409745115-1423-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1409745115-1423-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 07:51 AM, Daniel Thompson wrote:
> Universally adopt container_of() for all pointer conversion from
> uart_port to uart_amba_port.

Thanks.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-serial@vger.kernel.org
> ---
> 
> Notes:
>     This patch was written after a review comment made by Peter Hurley in
>     response to code that is no longer needed.  However I'd already written
>     it before I realized the code was no longer needed and it still appears
>     to be a sensible, if rather minor, bit of modernization.
>     
> 
>  drivers/tty/serial/amba-pl011.c | 54 +++++++++++++++++++++++++++--------------
>  1 file changed, 36 insertions(+), 18 deletions(-)


