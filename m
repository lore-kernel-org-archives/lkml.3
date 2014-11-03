Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaKCVpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:45:45 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50181 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaKCVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:45:42 -0500
Message-ID: <1415051139.20372.85.camel@x220>
Subject: Re: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible
 string for device binding
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>
Cc: gyungoh@gmail.com, sameo@linux.intel.com, lee.jones@linaro.org,
        jg1.han@samsung.com, cooloney@gmail.com, lgirdwood@gmail.com,
        jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Date: Mon, 03 Nov 2014 22:45:39 +0100
In-Reply-To: <20141031164418.GC18557@sirena.org.uk>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
	 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
	 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
	 <20141031164418.GC18557@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2014 21:45:40.0138 (UTC) FILETIME=[82B6A8A0:01CFF7AF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 16:44 +0000, Mark Brown wrote:
> On Fri, Oct 31, 2014 at 04:08:41PM +0900, gyungoh@gmail.com wrote:
> > From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > 
> > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> This doesn't apply against current code and depends on the MFD symbol
> rename - can you please check what's going on here?
> 
> It would make sense to split the Kconfig symbol rename into a separate
> patch to ease merging,

The relicensing (from GPL to GPL v2, thus dropping the "or later"
provision) is odd too. The header still uses GPL v2 or later, doesn't
it? Anyhow, that could be a separate patch too.

> it doesn't seem obviously related to the driver
> change and should probably be in the same patch as the MFD symbol rename
> for bisetion.

I don't think there will be bisection problems (in mainline). Currently
this driver depends on SKY81452. But that symbol doesn't exist. Only
after both 1/8 and this patch will this driver become buildable, for the
first time. So it's not that this driver was buildable, became
unbuildable in 1/8 and buildable again in this patch.

(I don't think it's much of a problem that the regulator driver got
merged, in v3.18-rc1, before the mfd driver on which it depends.
Avoiding that temporarily problem appears to be more trouble than it's
worth.)


Paul Bolle

