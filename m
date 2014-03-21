Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbaCUPqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:46:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42990 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760251AbaCUPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:46:06 -0400
Date: Fri, 21 Mar 2014 15:45:59 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] regulator: arizona-ldo1: Add processing of
	init_data from device tree
Message-ID: <20140321154559.GG1665@opensource.wolfsonmicro.com>
References: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1395224338-3709-5-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140321103432.GF15213@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321103432.GF15213@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 10:34:32AM +0000, Lee Jones wrote:
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/arizona.txt |    7 +++
> 
> I can see why you're doing it like this, but it's probably best to do
> all of the document changes in one single (separate) patch.

I am happy to break this out into a seperate patch.

Thanks,
Charles
