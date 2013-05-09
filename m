Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3EIWhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:37:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab3EIWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:37:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/12] 3.0.78-stable review
Date: Thu,  9 May 2013 15:37:13 -0700
Message-Id: <20130509223611.432377360@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.78 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat May 11 22:34:47 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.78-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.78-rc1

Jerry Hoemann <jerry.hoemann@hp.com>
    x86/mm: account for PGDIR_SIZE alignment

Chen Gang <gang.chen@asianux.com>
    kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix ftrace_dump()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix possible segfault when parsing pm tables

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian bugs in atom_allocate_fb_scratch()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't use get_engine_clock() on APUs

David Müller <d.mueller@elsoft.ch>
    drm/i915: Fall back to bit banging mode for DVO transmitter detection

Christian Lamparter <chunkeey@googlemail.com>
    drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Hans Schillstrom <hans@schillstrom.com>
    ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

David Jeffery <djeffery@redhat.com>
    autofs - remove autofs dentry mount check

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    powerpc: fix numa distance for form0 device tree


-------------

Diffstat:

 Makefile                                 |  4 +--
 arch/powerpc/mm/numa.c                   |  2 +-
 arch/x86/mm/init.c                       |  5 ++++
 drivers/gpu/drm/i915/intel_dvo.c         | 13 +++++++-
 drivers/gpu/drm/i915/intel_lvds.c        |  8 +++++
 drivers/gpu/drm/radeon/atom.c            |  6 ++--
 drivers/gpu/drm/radeon/evergreen.c       | 10 +++++++
 drivers/gpu/drm/radeon/radeon_atombios.c | 10 ++++++-
 drivers/gpu/drm/radeon/radeon_pm.c       |  6 +++-
 fs/autofs4/expire.c                      |  9 ------
 kernel/audit_tree.c                      |  2 +-
 kernel/trace/trace.c                     | 51 +++++++++++++-------------------
 kernel/trace/trace_selftest.c            |  9 +++---
 net/netfilter/ipvs/ip_vs_pe_sip.c        |  6 +---
 14 files changed, 83 insertions(+), 58 deletions(-)


