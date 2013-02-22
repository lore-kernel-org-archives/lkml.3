Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3BVMrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:47:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab3BVMre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:47:34 -0500
Date: Fri, 22 Feb 2013 13:47:31 +0100
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Kbuild: Disable var tracking with
	CONFIG_DEBUG_INFO_REDUCED
Message-ID: <20130222124730.GI12402@pobox.suse.cz>
References: <1360274320-26833-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360274320-26833-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 01:58:40PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Newer gcc enables the var-tracking pass with -g to keep track which
> registers contain which variables. This is one of the slower passes in gcc.
> 
> With reduced debug info (aimed at objdump -S, but not using a full debugger)
> we don't need this fine grained tracking. But it was still enabled
> because -g was enabled. Disable it explicitely for DEBUG_INFO_REDUCED.

Applied to kbuild.git#kbuild, thanks.

Michal
