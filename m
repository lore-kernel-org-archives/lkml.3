Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaGAKCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:02:19 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:56938
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418AbaGAKCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:02:17 -0400
Date: Tue, 1 Jul 2014 16:30:08 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140701083007.GB26146@shlinux1.ap.freescale.net>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140627032506.GA18039@shlinux1.ap.freescale.net>
 <20140630133313.GA11880@kwain>
 <20140701002112.GA26146@shlinux1.ap.freescale.net>
 <53B27789.3090509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B27789.3090509@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(377454003)(479174003)(24454002)(51704005)(87936001)(99396002)(64706001)(84676001)(79102001)(33656002)(76482001)(95666004)(81156004)(85852003)(74662001)(31966008)(74502001)(26826002)(81342001)(4396001)(21056001)(85306003)(102836001)(83506001)(83322001)(83072002)(46102001)(92726001)(86362001)(107046002)(97736001)(23756003)(6806004)(92566001)(106466001)(68736004)(104016002)(44976005)(50466002)(105606002)(69596002)(93886003)(81542001)(80022001)(20776003)(76176999)(50986999)(77982001)(54356999)(47776003)(41533002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB092;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02596AB7DA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 10:55:37AM +0200, Sebastian Hesselbarth wrote:
> On 07/01/2014 02:21 AM, Peter Chen wrote:
> >On Mon, Jun 30, 2014 at 03:33:13PM +0200, Antoine Ténart wrote:
> >>On Fri, Jun 27, 2014 at 11:25:07AM +0800, Peter Chen wrote:
> >>>On Tue, Jun 24, 2014 at 12:35:16PM +0200, Antoine Ténart wrote:
> >>>>+
> >>>>+static const struct of_device_id ci_hdrc_generic_of_match[] = {
> >>>>+	{ .compatible = "chipidea-usb" },
> >>>>+	{ }
> >>>>+};
> >>>
> >>>Even as a generic driver, you can also use your own compatible string.
> >>
> >>Well, there is nothing specific about the Berlin CI. Some subsystems
> >>use the 'generic' keyword in these cases. Do you see a particular reason
> >>I should use some Berlin related compatible here?
> >
> >Not must, one suggestion is: can you change the compatible string
> >to "chipidea-usb-generic"?
> 
> I don't know about ChipIdea/ARC/DW's product portfolio but I guess
> the compatible should also carry '2.0' or 'usb2' in it. Or we just
> use some version number like 'chipidea,ci13000' or 'chipidea,ci13xxx'.
> 
> Sebastian
> 

The recommended format for compatible string is: "manufacturer,model",
I agree with "chipidea,ci13xxx", thanks.

-- 

Best Regards,
Peter Chen
