Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaIVHnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbaIVHnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:43:46 -0400
Date: Mon, 22 Sep 2014 09:43:15 +0200
From: Karel Zak <kzak@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        a.p.zijlstra@chello.nl, mingo@kernel.org, hpa@linux.intel.com,
        brice.goglin@gmail.com, bp@alien8.de
Subject: Re: [PATCH] x86: new topology for multi-NUMA-node CPUs
Message-ID: <20140922074315.GE5366@x2.net.home>
References: <20140918193334.C065EBCE@viggo.jf.intel.com>
 <20140919114529.GD5366@x2.net.home>
 <541C72A9.9090509@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541C72A9.9090509@sr71.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:15:05AM -0700, Dave Hansen wrote:
> On 09/19/2014 04:45 AM, Karel Zak wrote:
> >  hmm... it would be also nice to test it with lscpu(1) from 
> >  util-linux (but it uses maps rather than lists from cpu*/topology/).
> 
> Here's the output with and with out Cluster-on-Die enabled.
> 
> Everything looks OK to me.  The cache size changes are what the CPU
> actually tells us through CPUID leaves.

 Thanks Dave!

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
