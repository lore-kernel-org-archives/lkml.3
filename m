Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbaEPOSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:18:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbaEPOST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:18:19 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Larry.Finger@lwfinger.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel <devel@driverdev.osuosl.org>
Subject: Re: randconfig build error with next-20140516, in drivers/staging/rtl8723au/core/rtw_cmd.c
References: <CA+r1Zhh8=cjcheZEzS_cn0-n11s2RoXzHZS65U7XN4bbozKrCA@mail.gmail.com>
Date: Fri, 16 May 2014 16:18:09 +0200
In-Reply-To: <CA+r1Zhh8=cjcheZEzS_cn0-n11s2RoXzHZS65U7XN4bbozKrCA@mail.gmail.com>
	(Jim Davis's message of "Fri, 16 May 2014 06:42:59 -0700")
Message-ID: <wrfjha4px0wu.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Davis <jim.epost@gmail.com> writes:
> Building with the attached random configuration file,
>
> drivers/staging/rtl8723au/core/rtw_cmd.c: In function ‘c2h_evt_hdl’:
> drivers/staging/rtl8723au/core/rtw_cmd.c:1315:4: error: implicit declaration of
> function ‘c2h_handler_8723a’ [-Werror=implicit-function-declaration]
>     ret = c2h_handler_8723a(adapter, c2h_evt);
>     ^
> drivers/staging/rtl8723au/core/rtw_cmd.c: In function ‘rtw_evt_work’:
> drivers/staging/rtl8723au/core/rtw_cmd.c:1349:2: error: implicit declaration of
> function ‘c2h_id_filter_ccx_8723a’ [-Werror=implicit-function-declaration]
>   if (c2h_id_filter_ccx_8723a(ework->u.c2h_evt.id) == true) {
>   ^
> cc1: some warnings being treated as errors

Thanks for the report, I'll have a look.

Jes
