Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225Ab3IDXmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:42:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:64468 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966Ab3IDXmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:42:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,843,1371106800"; 
   d="scan'208";a="391219228"
From: Andi Kleen <andi@firstfloor.org>
To: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora>
Date: Wed, 04 Sep 2013 16:41:48 -0700
In-Reply-To: <20130903072944.4793.93584.stgit@hemant-fedora> (Hemant Kumar
	Shaw's message of "Tue, 03 Sep 2013 13:06:40 +0530")
Message-ID: <87ppsonohv.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com> writes:

> This series adds support to perf to list and probe into the SDT markers.
> The first patch implements listing of all the SDT markers present in
> the ELFs (executables or libraries). The SDT markers are present in the
> .note.stapsdt section of the elf. That section can be traversed to list
> all the markers. Recognition of markers follows the SystemTap approach.
>
> The second patch will allow perf to probe into these markers. This is
> done by writing the marker name and its offset into the
> uprobe_events file in the tracing directory.
> Then, perf tools can be used to analyze perf.data file.

Nice feature

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
