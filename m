Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720Ab3ICIZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:25:11 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57848 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555Ab3ICIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:25:08 -0400
Date: Tue, 3 Sep 2013 10:25:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
Message-ID: <20130903082503.GA20732@gmail.com>
References: <20130903072944.4793.93584.stgit@hemant-fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903072944.4793.93584.stgit@hemant-fedora>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com> wrote:

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

Please provide a better high level description that explains the history 
and scope of SDT markers, how SDT markers get into binaries, how they can 
be used for probing, a real-life usage example that shows something 
interesting not possible via other ways, etc.

Thanks,

	Ingo
