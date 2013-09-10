Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab3IJLTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:19:51 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:9845
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab3IJLTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:19:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI154dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 10 Sep 2013 19:19:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 12/19] cpufreq: cpufreq-cpu0: remove device tree
 parsing for cpu nodes
Message-ID: <20130910111947.GH5815@S2101-09.ap.freescale.net>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-13-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <Pine.LNX.4.64.1309061539310.11068@axis700.grange>
 <522D93D7.4010307@arm.com>
 <20130909143253.GD4624@S2101-09.ap.freescale.net>
 <522DE822.3030907@arm.com>
 <20130910024404.GC5815@S2101-09.ap.freescale.net>
 <522EFAD1.4020709@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <522EFAD1.4020709@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:56:17AM +0100, Sudeep KarkadaNagesha wrote:
> > So we only need to change all clkdev registration to use "cpu0" as
> > dev_id intstead of "cpufreq-cpu0.0", something like below.
> > 
> > And for imx, it should work even without the changes, because we have
> > device tree lookup ready there, and those clk_register_clkdev() calls
> > can just be removed now.  But I prefer to include the change and leave
> > the cleanup to another patch for keeping the change log clear.
> > 
> Ok makes sense, do you want me to include this patch also as fix.
> I can send a series to fix this if you OK:
> 1. Fix in cpufreq-cpu0
> 2. Fix in i.MX driver and platform file
> 3. Patch below

Yes, please.  Thanks.

Shawn

