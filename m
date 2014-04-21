Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaDUDoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 23:44:17 -0400
Received: from [65.55.169.136] ([65.55.169.136]:25195 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293AbaDUDoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 23:44:14 -0400
X-Greylist: delayed 1031 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2014 23:44:14 EDT
Message-ID: <1398050801.7753.7.camel@leyfoon-vm>
Subject: Re: [PATCH 01/28] nios2: Build infrastructure
From: Ley Foon Tan <lftan@altera.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Date: Mon, 21 Apr 2014 11:26:41 +0800
In-Reply-To: <1397850104.4750.8.camel@x220>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	 <1397824031-4892-2-git-send-email-lftan@altera.com>
	 <1397850104.4750.8.camel@x220>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(24454002)(51704005)(189002)(199002)(377424004)(74502001)(74662001)(77982001)(31966008)(77156001)(89996001)(16796002)(87936001)(33716001)(33646001)(87286001)(99396002)(76482001)(83072002)(85852003)(2009001)(20776003)(47776003)(79102001)(42186004)(83322001)(92726001)(92566001)(88136002)(6806004)(44976005)(23676002)(80022001)(46102001)(93916002)(97736001)(86362001)(50226001)(4396001)(81342001)(50986999)(81542001)(76176999)(62966002)(80976001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB035;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:F3D364A2.93F2A705.3DECB77E.88E13477.200C4;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0188D66E61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jum, 2014-04-18 at 21:41 +0200, Paul Bolle wrote:
> On Fri, 2014-04-18 at 20:26 +0800, Ley Foon Tan wrote:
> > diff --git a/arch/nios2/kernel/Makefile b/arch/nios2/kernel/Makefile
> [...]
> > +obj-$(CONFIG_CONSOLE)		+= console.o
> 
> CONFIG_CONSOLE seems never to be defined. And there appears to be no
> arch/nios2/console.c or .../console.S anyway.
> 
> 
> Paul Bolle
> 
Good catch. Will remove this.
Thanks.

Regards
Ley Foon

