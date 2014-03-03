Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaCCIAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:00:13 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52431 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaCCIAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:00:10 -0500
Date: Mon, 3 Mar 2014 16:00:01 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv4 0/7] Convert twl4030-madc to IIO API and add DT support
Message-ID: <20140303080001.GH4674@lee--X1>
References: <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393444990-28140-1-git-send-email-sre@debian.org>
 <5311CA14.6080009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5311CA14.6080009@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Mar 2014, Jonathan Cameron wrote:

> On 26/02/14 20:03, Sebastian Reichel wrote:
> >Hi,
> >
> >This is RFCv4 for converting twl4030-madc to the IIO API and
> >adding DT support. The patchset compiles and has been tested
> >on my Nokia N900.
> >
> >Changes since RFCv3 [0]:
> >  * Added Acked-by from Lee Jones (MFD subsystem maintainer)
> >    to twl_i2c_read/write_u16 patches
> >  * Fixed style issues found by Lee Jones
> >    This readded the temp variable Jonathan Cameron wanted to
> >    be removed, but makes the code cleaner - especially once
> >    the brackets for math for clarity are added.
> >  * Tested with converted rx51-battery driver on Nokia N900,
> >    which can be found at [1].
> >
> >[0] https://lkml.org/lkml/2014/2/25/627
> >[1] https://lkml.org/lkml/2014/2/25/639
> 
> Hi All,
> 
> Obviously there are a few outstanding bits and pieces to be addressed.
> 
> To get this lined up for a merge...
> 
> Lee, do you want to take this through mfd or shall I take it through
> IIO?  I don't mind either way.  It stands pretty separate in IIO so
> shouldn't cause any merge issues beyond minor fuzz.

I'm happy to take it through MFD with your Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
