Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaAPSts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:49:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaAPSto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:49:44 -0500
Date: Thu, 16 Jan 2014 18:49:40 +0000
From: Mel Gorman <mgorman@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TLB range flush] +34.7% hackbench.throughput
Message-ID: <20140116184940.GR4963@suse.de>
References: <1389278098-27154-1-git-send-email-mgorman@suse.de>
 <20140116140118.GA22224@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140116140118.GA22224@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:01:18PM +0800, Fengguang Wu wrote:
> Hi Mel,
> 
> I applied your patchset on v3.13-rc7 and get some test results. The
> results are encouraging: hackbench throughput increased by 34.7% with
> parameters 1600%-threads-pipe on a 2S SNB server.
> 
> In case you are interested, here are the full list of changes.
> kconfig is attached.
> 

I am intersted and thanks very much for the report. It's very encouraging.

-- 
Mel Gorman
SUSE Labs
