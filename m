Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaKXRpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:45:34 -0500
Received: from tex.lwn.net ([70.33.254.29]:60361 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaKXRpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:45:32 -0500
Date: Mon, 24 Nov 2014 10:45:30 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: SeongJae Park <sj38.park@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroups: Documentation: fix wrong cgroupfs paths
Message-ID: <20141124104530.78a0050e@lwn.net>
In-Reply-To: <1416847159-3895-1-git-send-email-sj38.park@gmail.com>
References: <1416847159-3895-1-git-send-email-sj38.park@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 01:39:19 +0900
SeongJae Park <sj38.park@gmail.com> wrote:

>   6) Attach that task to the new cgroup by writing its PID to the
> -    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
> +    /sys/fs/cgroup/cpuset tasks file for that cgroup.

That one looks like it was correct before the change...?  What am I
missing here?

Thanks,

jon
