Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaDUFCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:02:11 -0400
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:25842
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750744AbaDUFCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:02:05 -0400
Message-ID: <1398056520.7753.10.camel@leyfoon-vm>
Subject: Re: [PATCH 01/28] nios2: Build infrastructure
From: Ley Foon Tan <lftan@altera.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Date: Mon, 21 Apr 2014 13:02:00 +0800
In-Reply-To: <1397848572.4750.4.camel@x220>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	 <1397824031-4892-2-git-send-email-lftan@altera.com>
	 <1397848572.4750.4.camel@x220>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(24454002)(51704005)(189002)(199002)(377424004)(85852003)(83072002)(86362001)(87936001)(88136002)(89996001)(76176999)(99396002)(74662001)(87286001)(50986999)(31966008)(23676002)(93916002)(92726001)(92566001)(80022001)(62966002)(74502001)(16796002)(20776003)(97736001)(47776003)(2009001)(81542001)(6806004)(83322001)(44976005)(77982001)(33716001)(46102001)(50226001)(4396001)(80976001)(81342001)(76482001)(77156001)(33646001)(42186004)(79102001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB063;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:A3F56090.18F2BA41.FF63987E.BBE1DC87.200E5;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0188D66E61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jum, 2014-04-18 at 21:16 +0200, Paul Bolle wrote:
> On Fri, 2014-04-18 at 20:26 +0800, Ley Foon Tan wrote:
> > diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
> >[...]
> > +config GENERIC_FIND_NEXT_BIT
> > +	def_bool y
> 
> This one is not needed, see commit 63e424c84429 ("arch: remove
> CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}").
Okay, will remove this CONFIG.

> 
> > +config NO_IOPORT
> > +	def_bool y
> 
> Did you mean NO_IOPORT_MAP?
Yes, will change it to NO_IOPORT_MAP

Thanks.

Regards
Ley Foon
