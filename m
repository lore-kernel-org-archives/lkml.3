Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935957AbaH1GFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 02:05:07 -0400
Received: from mail-bn1on0099.outbound.protection.outlook.com ([157.56.110.99]:23742
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933771AbaH1GFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 02:05:05 -0400
X-Greylist: delayed 2079 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2014 02:05:04 EDT
Date: Thu, 28 Aug 2014 13:31:03 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/3] cpufreq: cpu0: Removes unnecessary IS_ERR check on
 clk
Message-ID: <20140828053102.GC23836@dragon>
References: <1409209212-18730-1-git-send-email-pramod.gurav@smartplayin.com>
 <1409209212-18730-2-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409209212-18730-2-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130536774818621151;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009012)(6009001)(448002)(189002)(199003)(24454002)(51704005)(50466002)(33716001)(46102001)(90102001)(46406003)(107046002)(76482001)(74502001)(95666004)(31966008)(106466001)(74662001)(68736004)(54356999)(110136001)(104016003)(77982001)(99396002)(85306004)(87936001)(102836001)(83072002)(85852003)(20776003)(47776003)(33656002)(81542001)(83506001)(19580405001)(92726001)(19580395003)(97756001)(85326001)(84676001)(26826002)(4396001)(79102001)(6806004)(64706001)(50986999)(76176999)(57986006)(81342001)(83322001)(23726002)(92566001)(80022001)(44976005)(86362001)(97736001)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB367;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=permerror (sender IP is 192.88.168.50)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:00:11AM -0700, Pramod Gurav wrote:
> This removes unnecessary IS_ERR check on clk when in failure path
> as execution wont reach till there with clk being a err.
> 
> CC: Shawn Guo <shawn.guo@linaro.org>
> CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> CC: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
