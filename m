Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3DYH3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:29:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3DYH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:29:48 -0400
Date: Thu, 25 Apr 2013 00:29:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v6 2/5] Migrate shutdown/reboot to boot cpu.
Message-Id: <20130425002939.208fcb91.akpm@linux-foundation.org>
In-Reply-To: <20130425065704.GE7806@gmail.com>
References: <1366802333-8890-1-git-send-email-holt@sgi.com>
	<1366802333-8890-3-git-send-email-holt@sgi.com>
	<20130424151749.30b0680dc9392b110537bcd5@linux-foundation.org>
	<20130425065704.GE7806@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013 08:57:04 +0200 Ingo Molnar <mingo@kernel.org> wrote:

> > PF_THREAD_BOUND was removed/replaced in linux-next's a9ab775bc
> > ("workqueue: directly restore CPU affinity of workers from CPU_ONLINE")
> 
> I don't see PF_THREAD_BOUND being removed by commit a9ab775bc. Did you 
> mean some other commit?

commit 14a40ffccd6163bbcd1d6f32b28a88ffe6149fc6
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Mar 19 13:45:20 2013 -0700

    sched: replace PF_THREAD_BOUND with PF_NO_SETAFFINITY
