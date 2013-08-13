Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab3HMXev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:34:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:46736 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab3HMXeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:34:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,873,1367996400"; 
   d="scan'208";a="386643388"
Date: Tue, 13 Aug 2013 16:34:49 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com,
        dsahern@gmail.com
Subject: Re: [PATCH v1 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130813233449.GK23412@tassilo.jf.intel.com>
References: <1376394957-31691-1-git-send-email-eranian@google.com>
 <1376394957-31691-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376394957-31691-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 01:55:57PM +0200, Stephane Eranian wrote:
> This patch adds support for the new PERF_RECORD_MMAP2
> record type exposed by the kernel. This is an extended
> PERF_RECORD_MMAP record. It adds for each file-backed
> mapping the device major, minor number and the inode
> number. This triplet uniquely identifies the source
> of a file-backed mapping. It can be used to detect
> identical virtual mappings between processes for instance.

Can you also add the generation number please?
That would make it even more unique.

-Andi
