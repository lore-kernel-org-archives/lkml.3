Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaAXSUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:20:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53035 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbaAXSUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:20:16 -0500
Date: Fri, 24 Jan 2014 18:19:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Feng Kan <fkan@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V4 5/5] Documentation: power: reset: Add documentation
 for generic SYSCON reboot driver
Message-ID: <20140124181948.GE4758@e106331-lin.cambridge.arm.com>
References: <1390504801-24483-1-git-send-email-fkan@apm.com>
 <1390504801-24483-6-git-send-email-fkan@apm.com>
 <20140124113920.GF814@e106331-lin.cambridge.arm.com>
 <52E2A901.4050707@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E2A901.4050707@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 05:55:13PM +0000, Christopher Covington wrote:
> On 01/24/2014 06:39 AM, Mark Rutland wrote:
> > On Thu, Jan 23, 2014 at 07:20:01PM +0000, Feng Kan wrote:
> >> Add documentation for generic SYSCON reboot driver.
> >>
> >> Signed-off-by: Feng Kan <fkan@apm.com>
> >> ---
> >>  .../bindings/power/reset/syscon-reboot.txt         |   16 ++++++++++++++++
> >>  1 files changed, 16 insertions(+), 0 deletions(-)
> >>  create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> new file mode 100644
> >> index 0000000..e9eb1fe
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> @@ -0,0 +1,16 @@
> >> +Generic SYSCON mapped register reset driver
> > 
> > Bindings should describe hardware, not drivers.
> 
> How is this different than what's done for PSCI?

A PSCI node in the DT defines a standard interface to a firmware which
is external to Linux. The PSCI binding does not contain the word
"driver", but describes the interface that the binding describes, with
reference to approriate documentation.

All I'm arguing for here is a description of the class of hardware this
is applicable to, rather than "this is what this particular driver
uses".

Thanks,
Mark.
