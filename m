Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJQPBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:01:52 -0400
Received: from mail-bn1bon0090.outbound.protection.outlook.com ([157.56.111.90]:1920
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752883AbaJQPBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:01:50 -0400
Date: Fri, 17 Oct 2014 09:54:52 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v6 0/4] pmbus: ltc2978: add regulator support
In-Reply-To: <20141016212415.GA27469@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1410170954320.13511@atx-linux-37>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com> <20141016212415.GA27469@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA015.apcprd03.prod.outlook.com (10.141.119.25) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(164054003)(199003)(51704005)(41574002)(95666004)(21056001)(4396001)(86152002)(76482002)(86362001)(102836001)(64706001)(50466002)(31966008)(77096002)(101416001)(97736003)(92566001)(20776003)(46406003)(110136001)(47776003)(122386002)(83506001)(42186005)(120916001)(40100003)(99396003)(53416004)(54356999)(50986999)(81156004)(106356001)(33716001)(66066001)(105586002)(85306004)(23726002)(76176999)(87976001)(19580395003)(69596002)(19580405001)(80022003)(107046002)(92726001)(46102003)(85852003)(276003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014, Guenter Roeck wrote:

> On Wed, Oct 15, 2014 at 01:55:06PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Each output has individual on/off control.
> > 
> > New in v6:
> >   * Much cleanup of the bindings document
> >   * s/vout_en/vout/g
> > 
> > Hopefully this is getting closer.  We will still have the potential problem of
> > repeated node names on boards on boards that have many regulators of the same
> > kind.  If this can be handled in the regulator layer, that might be great.  
> > If we handle it here, whatever we come up with will have to keep the same
> > name over reboots and be predictable enough to serve as regulator node names
> > in the DT.  I'm open for suggestions here.
> > 
> > This patchset now uses "regulator: of: Provide simplified DT parsing method"
> > which are in the next-20141014 tag of linux-next.
> > 
> Hi Alan,
> 
> Since the problems we have seen are in the regulator core code and not
> in your patches, I added the series to -next. I fixed up the 'compatible'
> example in the devicetree description, so there is no need to resubmit
> the patches.
> 
> Thanks,
> Guenter
> 

Hi Guenter,

Thanks!

Alan

