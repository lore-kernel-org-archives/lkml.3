Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaDUV2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:28:16 -0400
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:28870
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754482AbaDUV1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:27:45 -0400
Message-ID: <1398116021.12716.1.camel@dinh-ubuntu>
Subject: Re: [PATCHv2 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
From: Thor Thayer <tthayer@altera.com>
To: Pavel Machek <pavel@ucw.cz>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>,
        <tthayer.linux@gmail.com>, Borislav Petkov <bp@alien8.de>,
        <devicetree@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 21 Apr 2014 16:33:41 -0500
In-Reply-To: <20140421102750.GA27209@amd.pavel.ucw.cz>
References: <1397604610-20931-1-git-send-email-tthayer@altera.com>
	 <1397604610-20931-5-git-send-email-tthayer@altera.com>
	 <20140421102750.GA27209@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(24454002)(199002)(51704005)(189002)(377424004)(74502001)(16796002)(74662001)(19580395003)(19580405001)(76176999)(31966008)(76482001)(77982001)(46102001)(20776003)(47776003)(42186004)(44976005)(83322001)(77156001)(6806004)(79102001)(33646001)(50226001)(4396001)(93916002)(87286001)(84676001)(33716001)(81542001)(92726001)(92566001)(80022001)(86362001)(62966002)(80976001)(2009001)(97736001)(50466002)(23676002)(81342001)(87936001)(89996001)(83072002)(85852003)(99396002)(50986999)(88136002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB015;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:ADF2FE6D.AD281F18.49E19F93.90FFDBD9.201AD;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0188D66E61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-21 at 12:27 +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Thor Thayer <tthayer@altera.com>
> > 
> > Added EDAC support for reporting ECC errors of CycloneV
> > and ArriaV SDRAM controller.
> > - The SDRAM Controller registers are used by the FPGA bridge so
> >   these are accessed through the syscon interface.
> > - The configuration of the SDRAM memory size for the EDAC framework
> >   is discovered from the SDRAM Controller registers.
> > - Documentation of the bindings in devicetree/bindings/arm/altera/
> >   socfpga-sdram-edac.txt
> > - Correction of single bit errors, detection of double bit errors.
> > 
> > ---
> > v2: Use the SDRAM controller registers to calculate memory size
> >     instead of the Device Tree. Update To & Cc list. Add maintainer 
> >     information.
> 
> I'd reduce number of *s in the messages, otherwise
> 
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
> 
> for whole series.
> 								Pavel
> 
Hi Pavel.

Noted - I will make the change. Thank you for reviewing.

Thor

