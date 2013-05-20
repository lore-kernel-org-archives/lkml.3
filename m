Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3ETXe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:34:56 -0400
Received: from mx2.sisa.samsung.com ([63.166.156.250]:46663 "EHLO
	mx2.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab3ETXey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:34:54 -0400
X-ASG-Debug-ID: 1369092892-05112928472d6b0001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
CC: "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] Bluetooth: Add missing reset_resume dev_pm_ops
Thread-Topic: [PATCH] Bluetooth: Add missing reset_resume dev_pm_ops
X-ASG-Orig-Subj: Re: [PATCH] Bluetooth: Add missing reset_resume dev_pm_ops
Thread-Index: AQHORPCWYn5rgwEVikOQkuKYXOozt5kPSVwAgAAHWoA=
Date: Mon, 20 May 2013 23:34:51 +0000
Message-ID: <1369092891.8079.5.camel@lorien>
References: <1367250333.4938.20.camel@lorien> <20130520230832.GF17712@joana>
In-Reply-To: <20130520230832.GF17712@joana>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9812F29E36D93C4282B78399EE07FA12@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[105.144.21.115]
X-Barracuda-Start-Time: 1369092892
X-Barracuda-URL: http://192.168.0.102:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4KNZ286016630

On Mon, 2013-05-20 at 20:08 -0300, Gustavo Padovan wrote:
> Hi Shuah,
> 
> * Shuah Khan <shuah.kh@samsung.com> [2013-04-29 15:45:34 +0000]:
> 
> > Add missing reset_resume dev_pm_ops. Missing reset_resume results in the
> > following message after power management device test. This change sets
> > reset_resume to btusb_resume().
> > 
> > [ 2506.936134] btusb 1-1.5:1.0: no reset_resume for driver btusb?
> > [ 2506.936137] btusb 1-1.5:1.1: no reset_resume for driver btusb?
> > 
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > ---
> >  drivers/bluetooth/btusb.c |    1 +
> >  1 file changed, 1 insertion(+)
> 
> This patch needs rebase on latest bluetooth-next. It doesn't apply anymore.
> Please re-send it.
> 
> 	Gustavo

Hi Gustavo,

Yes. I will rebase and resend it you shortly.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group 
Samsung Research America (Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
