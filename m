Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3BVHBX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 22 Feb 2013 02:01:23 -0500
Received: from f282.mail.ru ([94.100.178.224]:50636 "EHLO f282.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab3BVHBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:01:22 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2NF0gbWZkOiBzeXNjb246IEFkZCBub24tRFQgc3Vw?=
 =?UTF-8?B?cG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Fri, 22 Feb 2013 11:01:18 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361516478.223331042@f282.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130222065548.GA3252@b29396-Latitude-E6410>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru> <20130222065548.GA3252@b29396-Latitude-E6410>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r1M71VoQ031869

> On Thu, Feb 21, 2013 at 07:29:02PM +0400, Alexander Shiyan wrote:
> > This patch allow using syscon driver from the platform data, i.e.
> > possibility using driver on systems without oftree support.
> > For search syscon device from the client drivers,
> > "syscon_regmap_lookup_by_pdevname" function was added.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> 
> [...]
> 
> > +	syscon->base = devm_ioremap_resource(dev, res);
> > +	if (!syscon->base)
> 
> Is this correct?

Hmm, of course IS_ERR should be used here...
v5?

> 
> > +		return -EBUSY;
> >
> 
> Otherwise, i'm also ok with this patch.
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> BTW, i did not see Samuel's tree having this new API.
> So, who will pick this patch?

I have same question.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
