Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaEUI7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:59:35 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:40289
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750761AbaEUI7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:59:24 -0400
Date: Wed, 21 May 2014 16:59:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@rjwysocki.net>, <linaro-kernel@lists.linaro.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arvind.chauhan@arm.com>, <inderpal.s@samsung.com>, <pavel@ucw.cz>,
        <nm@ti.com>, <chander.kashyap@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH 0/5] CPUFreq: Initialize CPU's OPP tables from core
Message-ID: <20140521085902.GA27211@dragon>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130451363619998562;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(199002)(189002)(83322001)(77096999)(33716001)(44976005)(83072002)(23726002)(85852003)(77982001)(86362001)(76176999)(54356999)(21056001)(50466002)(46102001)(76482001)(33656002)(87936001)(46406003)(50986999)(80022001)(6806004)(19580395003)(102836001)(19580405001)(558084003)(4396001)(64706001)(81542001)(83506001)(47776003)(20776003)(74662001)(81342001)(74502001)(31966008)(92726001)(92566001)(57986005)(97756001)(99396002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB413;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=softfail (sender IP is 192.88.158.246)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:47:20AM +0530, Viresh Kumar wrote:
> Viresh Kumar (5):
...
>   cpufreq: imx6q: don't initialize opp table
>   cpufreq: cpufreq-cpu0: don't initialize opp table

Acked-by: Shawn Guo <shawn.guo@linaro.org>
