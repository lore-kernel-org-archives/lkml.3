Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIYTHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:07:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56738 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaIYTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:07:10 -0400
Date: Thu, 25 Sep 2014 14:01:35 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 2/3] watchdog: qcom: document device tree bindings
Message-ID: <20140925190135.GK868@joshc.qualcomm.com>
References: <cover.1411667144.git.joshc@codeaurora.org>
 <f49033de078aff9112fb8fa6fa4331e16998edf2.1411667144.git.joshc@codeaurora.org>
 <20140925184314.GC12340@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925184314.GC12340@roeck-us.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:43:14AM -0700, Guenter Roeck wrote:
> On Thu, Sep 25, 2014 at 12:48:52PM -0500, Josh Cartwright wrote:
[..]
> > +- timeout-sec : shall contain the default watchdog timeout in seconds,
> > +                if unset, the default timeout is 30 seconds
> 
> Hi Josh,
> 
> timeout-sec is optional, not mandatory.

Indeed, I made this change in v2, but didn't reflect it in the document.
Good catch. Will fix.

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
