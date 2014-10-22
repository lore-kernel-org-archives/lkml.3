Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbaJVMaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:30:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26454 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaJVMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:30:00 -0400
X-AuditID: cbfee61a-f79c06d000004e71-96-5447a3464c3c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, balbi@ti.com, dinh.linux@gmail.com,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
Date: Wed, 22 Oct 2014 14:29:20 +0200
Message-id: <3268098.KSgOqdC5fV@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <9429092.fliZzSsbVp@amdc1032>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
 <9429092.fliZzSsbVp@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jQV33xe4hBocvsVkcvF9vMWndASaL
	s8sOslms+rSG2WLlSW2LywsvsVpsm/6TzeLyrjlsFouWtTJbLHx9jcVi+5TpTBYPDu9ktzj5
	p5fR4tXBNhYHPo/ZDRdZPP6uesHssXPWXXaPO9f2sHn0X5vE7vF31n4Wj74tqxg9vvz4x+Kx
	Zf9nRo/jN7YzeXzeJOexcW5oAE8Ul01Kak5mWWqRvl0CV0brrPssBadZKlZ9usjUwHiPuYuR
	g0NCwETix0bbLkZOIFNM4sK99WwgtpDAdEaJp1utuhi5gOwWJon9fWuZQRJsAlYSE9tXMYLY
	IgJKEr2rXrKA2MwCG5kk3n+zALGFBTwlmv/sBqtnEVCVuLDwCpjNK6Ap8eHZO7AFokA1O7av
	BLM5BbQkzr/4wg6xbDOjxMZVU1ggGgQlfky+B7VAXmLf/qmsELaOxP7WaWwTGAVmISmbhaRs
	FpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY+2Z1A7GlQ0WhxgFOBiVeHgd2NxD
	hFgTy4orcw8xSnAwK4nwKtUDhXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5N
	LUgtgskycXBKNTAy8Dw2+rfBeE7sii9224Lj42MOfC74xadS+eOD6e5f1/M/3N7263GnbF7C
	PpUNPZ9PTf68ahIPW95XV4Gy96JX2Y0uF8777idd75H3pfjl3ZAH8474VP1JbBNoWpB4m2HG
	MqspR9S/8u1aGryj4OCFTkX9N7G/zs3I7k643svB5W/pq53YszFXiaU4I9FQi7moOBEAOAQC
	3bECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 22, 2014 02:25:46 PM Bartlomiej Zolnierkiewicz wrote:

> BTW It is a bit late but it would be great if you could split your
> patchset on two.  First one merging gadget functionality into
> core/platform code and the second one adding USB_DWC2_DUAL_ROLE
> functionality.

On the second thought I think that the dual-role is needed to preserve
existing functionality (available through separate gadget and host
drivers) so please scrap the above comment.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

