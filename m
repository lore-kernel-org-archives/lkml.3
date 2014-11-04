Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaKDJFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:05:53 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:58394 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbaKDJFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:05:49 -0500
Message-ID: <1415091946.20372.136.camel@x220>
Subject: Re: [RESUBMIT PATCH v6 1/8] mfd: Add support for Skyworks SKY81452
 driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Lee Jones <lee.jones@linaro.org>
Cc: gyungoh@gmail.com, sameo@linux.intel.com, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com,
        jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Date: Tue, 04 Nov 2014 10:05:46 +0100
In-Reply-To: <20141103223022.GE13359@x1>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
	 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
	 <1414739322-12487-2-git-send-email-jack.yoo@skyworksinc.com>
	 <20141103171451.GG12011@x1> <1415050088.20372.72.camel@x220>
	 <20141103223022.GE13359@x1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2014 09:05:47.0619 (UTC) FILETIME=[85DE1B30:01CFF80E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 22:30 +0000, Lee Jones wrote:
> On Mon, 03 Nov 2014, Paul Bolle wrote:
> 
> > On Mon, 2014-11-03 at 17:14 +0000, Lee Jones wrote:
> > That patch makes REGULATOR_SKY81452 depend on MFD_SKY81452,
> > making it buildable.
> 
> Okay, so I can take this patch with no fall-out then.

Nothing will break. But I think Mark prefers the dependency rename, now
done in 7/8, to be done as part of this patch.


Paul Bolle

