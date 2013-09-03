Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172Ab3ICOWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:22:05 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59060 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3ICOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:22:03 -0400
Date: Tue, 3 Sep 2013 16:21:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Hemant <hkshaw@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
Message-ID: <20130903142159.GA27740@gmail.com>
References: <20130903072944.4793.93584.stgit@hemant-fedora>
 <20130903082503.GA20732@gmail.com>
 <5225A937.2050507@hitachi.com>
 <5225E2C5.3080001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5225E2C5.3080001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hemant <hkshaw@linux.vnet.ibm.com> wrote:

> Here is an overview and a high-level-description:

Thanks, looks like a pretty useful feature - especially if SDT probes are 
already widely present in various server binaries on a typical Linux 
distro (are they?).

Would be nice to stick some or all of that info into 
tools/perf/Documentation/sdt-probes.txt, and put the most useful part of 
that info into the man page as well - or something like that.

Thanks,

	Ingo
