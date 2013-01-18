Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3ARXZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:25:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:53455 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3ARXZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:25:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="275683388"
Date: Fri, 18 Jan 2013 15:25:43 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 15/18] perf: add PERF_RECORD_MISC_MMAP_DATA to
 RECORD_MMAP
Message-ID: <20130118232543.GN4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-16-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-16-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 04:39:43PM +0100, Stephane Eranian wrote:
> Type of mapping was lost and made it hard for a tool
> to distinguish code vs. data mmaps. Perf has the ability
> to distinguish the two.
> 
> Use a bit in the header->misc bitmask to keep track of
> the mmap type. If PERF_RECORD_MISC_MMAP_DATA is set then
> the mapping is not executable (!VM_EXEC). If not set, then
> the mapping is executable.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
