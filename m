Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab3HBT3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:29:37 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50718 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3HBT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:29:35 -0400
Date: Fri, 2 Aug 2013 15:29:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/5] sata, highbank: fix ordering of SGPIO signals
Message-ID: <20130802192928.GA29736@mtj.dyndns.org>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <20130729165530.GG22605@mtj.dyndns.org>
 <51FBCF05.9090509@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FBCF05.9090509@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 02, 2013 at 10:23:49AM -0500, Mark Langsdorf wrote:
> I didn't think I needed more of an explanation than "this is completely
> wrong per the spec" but I'll revise and resubmit.

Of course you always need to explain the implications as the result of
"being completely wrong per the spec" can range from no actual effect
at all to massive data corruption.  In general, it's a good idea for a
patch descrpition to describe why the change is an improvement and how
it changes the behavior.  The former provides the rationale for
inclusion and the latter helps various people including the subsystem,
-stable and distro kernel maintainers to assess the risk involved in
taking the change.

Thanks.

-- 
tejun
