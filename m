Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaFXWID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaFXWIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:08:02 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Clement Calmels <clement.calmels@free.fr>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix sparse warning
References: <1403643474-7991-1-git-send-email-clement.calmels@free.fr>
Date: Wed, 25 Jun 2014 00:07:51 +0200
In-Reply-To: <1403643474-7991-1-git-send-email-clement.calmels@free.fr>
	(Clement Calmels's message of "Tue, 24 Jun 2014 22:57:54 +0200")
Message-ID: <wrfjmwd2x8p4.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clement Calmels <clement.calmels@free.fr> writes:
> From: Clément Calmels <clement.calmels@free.fr>
>
> Found running sparse on the rtl8723au driver.
>
>   CHECK   drivers/staging/rtl8723au/core/rtw_cmd.c
> drivers/staging/rtl8723au/core/rtw_cmd.c:1479:54: warning: incorrect type in argument 2 (different base types)
> drivers/staging/rtl8723au/core/rtw_cmd.c:1479:54:    expected int [signed] gfp
> drivers/staging/rtl8723au/core/rtw_cmd.c:1479:54:    got restricted gfp_t
>
> Signed-off-by: Clement Calmels <clement.calmels@free.fr>
> ---
>  drivers/staging/rtl8723au/core/rtw_mlme.c    | 2 +-
>  drivers/staging/rtl8723au/include/rtw_mlme.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Thanks, I'll add it to my tree!

Cheers,
Jes
