Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3I0OiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:38:07 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51306 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753443Ab3I0OiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:38:05 -0400
Date: Fri, 27 Sep 2013 15:37:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Vineet Gupta <vgupta@synopsys.com>, Will Deacon <Will.Deacon@arm.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        James Hogan <james.hogan@imgtec.com>, Jonas Bonn <jonas@southpole.se>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 21/21] of: remove empty arch prom.h headers
Message-ID: <20130927143721.GD26069@arm.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
 <1380221456-11192-22-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380221456-11192-22-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 07:50:56PM +0100, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Now that prom.h is optional, all the empty prom.h headers can be removed.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: James Hogan <james.hogan@imgtec.com>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
