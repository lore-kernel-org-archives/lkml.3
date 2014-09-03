Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaICJDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:03:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64057 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbaICJDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:03:22 -0400
Date: Wed, 3 Sep 2014 10:03:01 +0100
From: Will Deacon <will.deacon@arm.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Gregory Fong <gregory.0xf0@gmail.com>, Matt Porter <mporter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: drop ISAR0 workaround for B15
Message-ID: <20140903090301.GA32378@arm.com>
References: <1407797053-12544-1-git-send-email-gregory.0xf0@gmail.com>
 <20140813194047.GA18411@ld-irv-0074>
 <20140902234924.GZ18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902234924.GZ18411@ld-irv-0074>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 12:49:24AM +0100, Brian Norris wrote:
> Ping.
> 
> Is this worthy of 3.17-rc? Or should it just be queued for 3.18, as it's
> only removing redundant info?

Since it's not actually fixing anything, I don't think it qualifies as a
fix. You can still put it into rmk's patch system though, as I don't see
this conflicting with anything in the pipeline.

Will
