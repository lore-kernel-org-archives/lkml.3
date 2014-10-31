Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbaJaPq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:46:26 -0400
Received: from pluto.manitu.net ([217.11.48.9]:60839 "EHLO pluto.manitu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbaJaPqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:46:13 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 11:46:12 EDT
To: <stable@vger.kernel.org>
Subject: [drm/i915: Do not store the error pointer for a failed userptr  registration] Candidate for stable =?UTF-8?Q?tree=3F?=
X-PHP-Originating-Script: 1000:func.inc
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Oct 2014 16:41:02 +0100
From: Peter Weber <peter.weber@ttyhoney.com>
Cc: <linux-kernel@vger.kernel.org>
Message-ID: <574931b8edea4d60014d5e9b31daa4a1@ttyhoney.com>
User-Agent: RoundCube Webmail/0.2-beta
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Is the patch[0] mentioned in the subject a possible candidate for the next
release of the stable kernel, at time of writing "3.17.3"? It looks like,
this is
causing serious problems and we are currently discussing this on the
bugtracker of
Archlinux[1].

I'm not sure if I'm personally affected. I suffered unexpected freezes
since 3.17-rc4 on my machine, at least STDIO and STDOUT are frozen. Maybe
the
reaction differs based on the kernel options (see changed behaviour
through
CONFIG_PREEMPT_VOLUNTARY=y). In my case, I don't see a null pointer in my
log
files.

I hope this doesn't offend against the stable kernel rules.

[0]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e9681366ea9e76ab8f75e84351f2f3ca63ee542c
# commit id is: e9681366ea9e76ab8f75e84351f2f3ca63ee542c
# already send to stable@vger.kernel.org, but not included in current
stable "3.17.2"
[1] https://bugs.archlinux.org/task/42353

Thank you
Peter
