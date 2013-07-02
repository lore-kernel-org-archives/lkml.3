Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3GBARu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:17:50 -0400
Received: from nm26-vm6.access.bullet.mail.bf1.yahoo.com ([216.109.115.213]:38062
	"EHLO nm26-vm6.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab3GBARt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:17:49 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 20:17:48 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 875230.74012.bm@omp1009.access.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Gd5gC6hk1j4sXy3AKn2eh2C7nf/au0VpdVLyLivE+UTsxZZuSVDU0+VLgqs5BAUnpkMXho2bGl/7HKFICysLBBUQ9T3hq9Fb+K7Sl6OXUffoIlJSOqpJn9FxUC9igEMjp8W/ANOeEyRCIH/cye4R4tqO7FYl+wwm9DP6L9chBbA=  ;
X-YMail-OSG: k70scjsVM1kJHfrFL94yZI0pY95yUqFlscrPbE3uuIH8LSK
 z25F3TdR6NoQz290t8NEOWTGlobTcd2cNIeDo4LTcAYOsjiZx7yTnFaXg.XA
 uhA5oVSkS4FfrYJasvNi7QbzCA5nXC1uQ9Qqlsljv_q_MwgF5yco4Q0mqB.q
 WX_Na1Podx5GlyM1kFYWsT8XZn2VjoC5o3tjkW1_NNjXbjITKaKLHF5ZcL55
 BKgB91862kdvG9P.8bpMEkyHH9NnrPWUs8wSuxt3iv1GnAn1O2FoJMtEutfT
 cnUyrt8N8wP94Ft7uR5CzeodDMzSyAzWTbUyA._Gq7DxD_gnvQ2Hz9tGkjbv
 waehdD4bm37n0um9wj3IQMAsLrbSm1PI.m_lkeQbHJ7BGhm9K4gc_RCzodjp
 iJAoA8pL3BTRQOUfnFQcCVi1t4Bh14lfQD0c1yzQbXDJWDv4ppXLCWgTjiZu
 NLr9hio1ed829HGUw0U5ARWSvFMtKc8wBcF.1AduSLMl8f0Vk_zqEfZLTyWF
 5oTGCKvtS2gYBNHAbU7a.TG8CCscvZvOICeXg6AP8H1A46ulNRgLDcSE.HCY
 q8CLpW4bLyuly3ZTO07CUt.W7JH7C3JjsYx07OmI0mg--
X-Rocket-MIMEInfo: 002.001,RGVhciBMaW51eC1LZXJuZWwgQ29tbXVuaXR5LAoKSSBhbSBhIGNvbnN1bHRhbnQgc3BlY2lhbGl6aW5nIGluIGJ1aWxkcywgYW5kIEkgcmVjZW50bHkgd29ya2VkIGZvciBhIGxhcmdlIGNsaWVudCBjb21wYW55LCBhIHdvcmxkLXdpZGUgbGVhZGVyIGluIGl0cyBmaWVsZCwgd2hlcmUgSSBvdmVyaGF1bGVkIHRoZWlyIGJ1aWxkIHN5c3RlbTogc3BlZCBpdCB1cCBieSBtb3JlIG9mIGFuIG9yZGVyIG9mIG1hZ25pdHVkZSwgYW5kIGltcHJvdmVkIG1haW50YWluYWJpbGl0eSwgZm9yIGV4YW1wbGUgbWFraW5nIGMBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.148.557
Message-ID: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com>
Date: Mon, 1 Jul 2013 17:12:01 -0700 (PDT)
From: Mark Galeck <mark_galeck@pacbell.net>
Reply-To: Mark Galeck <mark_galeck@pacbell.net>
Subject: is it desirable to improve the build system?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux-Kernel Community,

I am a consultant specializing in builds, and I recently worked for a large client company, a world-wide leader in its field, where I overhauled their build system: sped it up by more of an order of magnitude, and improved maintainability, for example making comment-to-code ratio approach 1:1. 

A part of their build is a modified Linux kernel. I rebuilt it countless times in various configurations, but made only a few further changes, because those improvements would have a small effect on the whole system, and because they want to stay close to your current release for ease of porting.

>From that limited experience, it nevertheless seemed to me, that the Linux kernel build, while correct, is somewhat slow, and the sources could be more readable.

Does the Linux-Kernel Community perceive that is the case?

If so, do you think it is possible to improve?

If so, would such an attempt be welcome, including and especially by, the current maintainer(s) of the build?  Of course it would have to be completely backwards-compatible, including to the text output interface and requirements for modules makefiles.

I do apologize if my impressions are simply the result of unfamilliarity and naivete, and that I don't understand the deep reasons why "it has to be this way", and that I am unaware that such attempts were already made by some very skilled people.  

Thank you,

Mark
