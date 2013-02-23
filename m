Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3BWFVX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 23 Feb 2013 00:21:23 -0500
Received: from fallback6.mail.ru ([94.100.176.134]:57453 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3BWFVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 00:21:20 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?VGhpZXJyeSBSZWRpbmc=?= <thierry.reding@avionic-design.de>
Cc: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <b29396@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        gregkh@linuxfoundation.org
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2NF0gbWZkOiBzeXNjb246IEFkZCBub24tRFQgc3Vw?=
 =?UTF-8?B?cG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sat, 23 Feb 2013 09:10:56 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361596256.286457090@f97.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130222085212.GA27653@avionic-0098.mockup.avionic-design.de>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru> <20130222082954.GD3252@b29396-Latitude-E6410> <20130222085212.GA27653@avionic-0098.mockup.avionic-design.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r1N5LSiR002156

> On Fri, Feb 22, 2013 at 04:29:55PM +0800, Dong Aisheng wrote:
> > On Fri, Feb 22, 2013 at 08:27:19AM +0100, Thierry Reding wrote:
> > ...
> > > > > > Otherwise, i'm also ok with this patch.
> > > > > > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> > > > > > 
> > > > > > BTW, i did not see Samuel's tree having this new API.
> > > > > > So, who will pick this patch?
> > > > > 
> > > > > I have same question.
> > > > 
> > > > I CCed Thierry and Greg who may know it.
> > > 
> > > Yes, devm_ioremap_resource() never returns NULL. You always need to
> > > check the returned pointer with IS_ERR(). The value that you return
> > > should be extracted from the pointer with PTR_ERR().
> > 
> > Thanks Thierry.
> > Since Samuel's mdf tree does not have your patch introducing
> > the new API of devm_ioremap_resource,
> > do you know which tree this patch can go through, Greg's driver core tree?
> 
> I don't think it matters much at this point because Linus merged the
> driver core tree yesterday, so anything that gets applied now should
> automatically have the new API available.

So, i will send all the three parts of the patch as v5 and keep all current CCs.
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
