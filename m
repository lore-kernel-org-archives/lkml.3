Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3GVXzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3GVXzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:55:22 -0400
Date: Mon, 22 Jul 2013 19:55:14 -0400
From: Dave Jones <davej@redhat.com>
To: trinity@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Trinity v1.2
Message-ID: <20130722235514.GA28463@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been six months since I last did a point release of trinity.
In that time, a lot has changed[*], supporting new syscalls, new options,
and fixing countless dumb bugs.

All that time of course, trinity has continued to find new kernel bugs.
It actually got to be too much work to track at one point.

There's a bunch of new features since 1.1, including preliminary
support for fuzzing ioctl() thanks to Tommi Rantala, and the beginning
of some interesting BPF fuzzing from Dan Borkmann, along with many
improvements to existing syscall fuzzers. (Special props to Vince Weaver
for his work on perf_event_open).

You can find the tarball and/or git instructions at
http://codemonkey.org.uk/projects/trinity/

My thanks to everyone else who contributed since the last release.
Being a sucker for stats, it's been fun to watch the graphs at
https://www.ohloh.net/p/7245 steadily increasing. Hope to see these
trends continue.

	Dave

[*]  581 files changed, 17782 insertions(+), 10253 deletions(-)
     Practically a rewrite given there are only 21k LOC in the project :)

