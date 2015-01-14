Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbbANKoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:44:34 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:50230 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbbANKoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:44:32 -0500
X-Greylist: delayed 4941 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 05:44:31 EST
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Wed, 14 Jan 2015 17:21:59 +0800
From: Barry Song <Barry.Song@csr.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Valentin Rothberg <valentinrothberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: clocksource: marco: CONFIG_ARCH_ATLAS7?
Thread-Topic: clocksource: marco: CONFIG_ARCH_ATLAS7?
Thread-Index: AQHQL9rTlQACRIMDNUSU/ZkN3cVgpZy+0NPQ
Date: Wed, 14 Jan 2015 09:21:53 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E90177A62F01@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1421225516.15397.41.camel@x220>
In-Reply-To: <1421225516.15397.41.camel@x220>
Accept-Language: en-US, zh-CN, en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.5.73]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0EAilPA005623

> 
> -----Original Message-----
> From: Paul Bolle [mailto:pebolle@tiscali.nl] 
> Sent: 2015å¹´1æœˆ14æ—¥ 16:52
> To: Barry Song
> Cc: Valentin Rothberg; Arnd Bergmann; Daniel Lezcano; Thomas Gleixner; linux-kernel@vger.kernel.org
> Subject: clocksource: marco: CONFIG_ARCH_ATLAS7?
> 
> Barry,
> 
> Your commit 81428bbe1d8a ("clocksource: marco: Rename marco to atlas7") is included in today's linux-next (ie, next-20150114). I noticed because a script I use to check linux-next spotted a problem.
> 
> See, your commit renames one reference to CONFIG_ARCH_MARCO to CONFIG_ARCH_ATLAS7. But there's no Kconfig symbol ARCH_ATLAS7 in linux-next yet. I assume that one or more patches to add ARCH_ATLAS7 (or to rename ARCH_MARCO to ARCH_ATLAS7) are queued somewhere. Is that correct?
> 
> 
Yes, paul.
It is queuing in arm-soc for refining my pull-request. Related patches have been acked by Arnd.

> Paul Bolle
>

-barry



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
