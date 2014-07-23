Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbaGWKLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:11:53 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:47032
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757564AbaGWKLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:11:51 -0400
Date: Wed, 23 Jul 2014 17:59:54 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: Re: [PATCH 1/2] ASoC: fsl_sai: Reset FIFOs after disabling TE/RE
Message-ID: <20140723095953.GB25639@MrMyself>
References: <cover.1405603108.git.nicoleotsuka@gmail.com>
 <9ef07dc9cc98b19e3f81f8374617605bf0d9faeb.1405603108.git.nicoleotsuka@gmail.com>
 <20140718101810.GA15150@MrMyself> <20140723095229.GA25639@MrMyself>
 <20140723100746.GC17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140723100746.GC17528@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(189002)(199002)(51704005)(95666004)(81542001)(50986999)(33716001)(83322001)(106466001)(46406003)(6806004)(74662001)(104016003)(84676001)(99396002)(44976005)(85852003)(50466002)(80022001)(107046002)(26826002)(83072002)(76176999)(81342001)(79102001)(46102001)(21056001)(102836001)(93886003)(23726002)(97736001)(77982001)(83506001)(54356999)(105606002)(4396001)(87936001)(74502001)(47776003)(85306003)(31966008)(92566001)(33656002)(92726001)(68736004)(97756001)(20776003)(76482001)(86362001)(64706001)(110136001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0610;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:07:46AM +0100, Mark Brown wrote:
> On Wed, Jul 23, 2014 at 05:52:32PM +0800, Nicolin Chen wrote:
> 
> > I found this two patches are merged into for-next branch, although I haven't
> > got the 'applied' email. 
> 
> > Is that possible for you to drop this one? If not, I'll send another patch
> > to fix this.
> 
> Please send a patch, I'd already applied it by the time you asked me to
> drop it.

Got it. Thank you.
Nicolin
