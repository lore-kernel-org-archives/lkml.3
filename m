Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945934AbaD3Q6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:58:13 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:44460
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945912AbaD3Q6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:58:11 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of
 devpriv->s_EeParameters
Thread-Topic: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of
 devpriv->s_EeParameters
Thread-Index: AQHPY4ZnHPwFiimH2UOrIUkZMgSYGJspCbaQgAE22QCAAB+ZAA==
Date: Wed, 30 Apr 2014 16:58:10 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E261E9@P3PWEX4MB008.ex4.secureserver.net>
References: <1398562711-6313-1-git-send-email-chase.southwood@gmail.com>
	<1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E24280@P3PWEX4MB008.ex4.secureserver.net>
 <CA+jnaaV7YDQYAGg_yksfiD31bCGN0brvZvBqi0VrK6hV_moxzA@mail.gmail.com>
In-Reply-To: <CA+jnaaV7YDQYAGg_yksfiD31bCGN0brvZvBqi0VrK6hV_moxzA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3UGwOAR009200

On Wednesday, April 30, 2014 12:52 AM, Chase Southwood wrote:
> Thanks so much, I greatly appreciate the review.  I'll fix the
> changelog for patch 4 and send once more (as I assume that's easier
> for Greg).  Also, I should know better about the cover letter as
> well...I was once told not to send them for strictly cleanup patchsets
> (as Greg can't do anything with them and cleanups should be obvious)
> but I've gotten in the habit of not doing a cover letter for any
> patchsets.  I will send cover letters (and be more careful about my
> other mistakes) in the future.

Chase,

Good job on the cleanup you have done so far.

The cover letter does not get committed as part of the patch set. But
when you are submitting a series it give a convenient  place to add
the sign off tag for a series. Also, if you would have done a cover letter
for this series you would have probably spotted the subject line issues
in patches 5 and 6.

Keep up the good work!

Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
