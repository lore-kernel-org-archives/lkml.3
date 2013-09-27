Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3I0Oha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:37:30 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51014 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753339Ab3I0Oh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:37:28 -0400
Date: Fri, 27 Sep 2013 15:37:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 04/21] arm64: remove unnecessary prom.h include
Message-ID: <20130927143702.GC26069@arm.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
 <1380221456-11192-5-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380221456-11192-5-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 07:50:39PM +0100, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Remove unnecessary prom.h include in preparation to make prom.h optional.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
