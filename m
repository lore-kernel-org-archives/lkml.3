Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaIPTv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:51:58 -0400
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:52180
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754468AbaIPTv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:51:57 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 15:51:56 EDT
Date: Tue, 16 Sep 2014 14:21:55 -0500
From: Brian Austin <brian.austin@cirrus.com>
X-X-Sender: heelrod@heelrod
To: Fabian Frederick <fabf@skynet.be>
CC: <linux-kernel@vger.kernel.org>, Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 1/1 linux-next] ASoC: cs35l32: remove second linux/slab.h
 inclusion
In-Reply-To: <1410894151-6246-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1409161418590.27378@heelrod>
References: <1410894151-6246-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.128.20;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(199003)(189002)(51704005)(24454002)(77096002)(44976005)(19580405001)(90102001)(76482001)(106466001)(110136001)(21056001)(95666004)(102836001)(558084003)(83322001)(4396001)(46406003)(92726001)(87936001)(50986999)(23726002)(81542003)(76176999)(47776003)(107046002)(74662003)(86362001)(54356999)(50466002)(64706001)(46102003)(85852003)(83072002)(19580395003)(31966008)(81342003)(99396002)(33716001)(20776003)(74502003)(85306004)(92566001)(77982003)(83506001)(80022003)(79102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB030;H:mail2.cirrus.com;FPR:;MLV:sfv;PTR:mail2.cirrus.com;A:1;MX:3;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=temperror (sender IP is 141.131.128.20)
 smtp.mailfrom=Brian.Austin@cirrus.com; 
X-OriginatorOrg: cirrus.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 16 Sep 2014, Fabian Frederick wrote:

> linux/slab.h was included twice.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
Acked-by: Brian Austin <brian.austin@cirrus.com>

Thanks,

