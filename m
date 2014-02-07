Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaBGTMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:12:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50241 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaBGTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:12:14 -0500
Date: Fri, 7 Feb 2014 13:12:12 -0600
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
Message-ID: <20140207191212.GB19974@qualcomm.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <1391766753.27491.60.camel@iivanov-dev>
 <20140207173207.GA19974@qualcomm.com>
 <20140207175234.GJ1757@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207175234.GJ1757@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:52:34PM +0000, Mark Brown wrote:
> On Fri, Feb 07, 2014 at 11:32:07AM -0600, Andy Gross wrote:
> > On Fri, Feb 07, 2014 at 11:52:33AM +0200, Ivan T. Ivanov wrote:
> 

[... snip ...]

> > The platform doesn't have support for PM right now.  So it's probably better to
> > remove all this and revisit later when it is in place.
> 
> No, runtime PM does not require any platform support at all and is good
> practice - look at what the driver is doing with it, it's useful as-is.

Fair enough.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
