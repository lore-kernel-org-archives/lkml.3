Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3GKVWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 17:22:20 -0400
Received: from nm27-vm5.access.bullet.mail.bf1.yahoo.com ([216.109.115.228]:37895
	"EHLO nm27-vm5.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790Ab3GKVWQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 17:22:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 203993.58156.bm@omp1029.access.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Co4s1j8HP7xXsvcZxPv+Yjkd941ME4yVjMdoiEBkD3kpLJk83F3KHAAHvsUq1KT0CX00kxiF/GRCAdbbUCxJ7w+HsvrGoZ8uKNLsDq7U89Dcozt19Zurj6+3OOt1bPZn5nKkqLvIDMsOmWct1RvHwYPe2Q7HwOMFD7mAcn3onu8=  ;
X-YMail-OSG: OsuHeoAVM1kIaHpDmis.rKfs69gbNsQ01.wa0bXJPrpGftJ
 l39FvC7hdfNVjI4H0oeG68Q9UQ1nJvy79MqqEW1v0Hpxyhlt2PV35eojqhCB
 Hb54mikJYls2AiDUmlbC3tixWnda98nZ2wJbEricvYBLcyKoEE2X4Zl40y2A
 pEFEElnsGAB.NTv0FMaRT.CYuTRf4Jp02kuNbgRa.E0byJzh5CfQYNi.1GuB
 O4pLSbpPG81YtDD3quPsq2WC0mDctQBsWTLK88l8WN7_VLhS3cFJfQTZCASy
 xFgx0DOObIEEXDaRrgm_NOMeFgZ5quyyeKy44vbKT4oeFRm6AUyQ2aE_Uzs4
 4qltY5oTeey_eYfkjxdKJmcnZKxIXrsnT8nMGPovy.2lQnDGKfJp854.vOQR
 wrUqV1BPJBRqdeQuTeWi5SrMLT4_9ycgt8fcPi2bgwdLaLlhwZmCzQoLFg.N
 3eUSGdE5xJGxMQ2jB9NkbYlUWWUHChQ5Suh5IWO.BCrcRxnZdSvdi3LnWENT
 ylrwKABH_DhqAcRR_jm6lGj5dgl9Zizhk.ALzE1hf9vDHBQlsFwBSxlHVceR
 JnftRsDvYkQGuCUAxvMLIZg7q9jO7XflJTe_toppJQOvenGv4a1N1CxaxhGr
 NdPbv
X-Rocket-MIMEInfo: 002.001,PlRoZSBhbnN3ZXIgdG8gImlzIGl0IGRlc2lyYWJsZSB0byBpbXByb3ZlIFg_IiBpcyBhbHdheXMgInllcy4iwqAgQnV0Cgp0aGUgb25seSB3YXkgdG8gbWFrZSBwcm9ncmVzcyBpbiBMaW51eCBpcyB0byBhY3R1YWxseSBwb3N0IHBhdGNoZXMKdGhhdCAiaW1wcm92ZSBYLiLCoCBUaGlzIGlzIHVubGlrZSBtYW55IGNvcnBvcmF0ZSBlbnZpcm9ubWVudHMsIHdoZXJlCnlvdSBtaWdodCBuZWVkIHRvIGdldCBzb21lYm9keSdzIGFwcHJvdmFsCgoKUHJlY2lzZWx5LiBQbGVhc2UgZXhjdXNlIG1lIGNvbWluZyBmcm8BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.148.557
References: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com> <20130711113822.GA18579@amd.pavel.ucw.cz> <CAErSpo5Jsbh8fcUXt_GL=ihv-3yq1SOD_UejC5MP=jBGowNn_w@mail.gmail.com>
Message-ID: <1373577734.39761.YahooMailNeo@web182202.mail.bf1.yahoo.com>
Date: Thu, 11 Jul 2013 14:22:14 -0700 (PDT)
From: Mark Galeck <mark_galeck@pacbell.net>
Reply-To: Mark Galeck <mark_galeck@pacbell.net>
Subject: Re: is it desirable to improve the build system?
To: Bjorn Helgaas <bhelgaas@google.com>, Pavel Machek <pavel@ucw.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAErSpo5Jsbh8fcUXt_GL=ihv-3yq1SOD_UejC5MP=jBGowNn_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The answer to "is it desirable to improve X?" is always "yes."  But

the only way to make progress in Linux is to actually post patches
that "improve X."  This is unlike many corporate environments, where
you might need to get somebody's approval


Precisely. Please excuse me coming from a corporate background. 
In corporate, even if you "get somebody's approval", there may be "other stakeholders" who may "feel ownership" etc etc


Thank you

Mark
