Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992526AbaEPXQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:16:07 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60065 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992485AbaEPXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:16:03 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org, Michael Lentine <mlentine@google.com>
Subject: [PATCH 0/2] perf tools: improve perf support on Android
Date: Sat, 17 May 2014 01:15:54 +0200
Message-Id: <1400282156-4661-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Lentine <mlentine@google.com>

This short series of patches allow for the execution of perf natively
on the android devices.

The following changes are implemented:

 - Have cat be the default page. Android does not have less or more pager.
   this is a generic change which cleans up the code a bit

 - Remap library paths to allow for data reporting on a linux pc with data
   collected from an android device.

Patches relative to tip.git.

Signed-off-by: Michael Lentine <mlentine@google.com>

Michael Lentine (2):
  perf tools: add a fallback for pager to use cat if less does not exist.
  perf tools: add automatic remapping of Android libraries

 tools/perf/util/map.c   | 89 ++++++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/pager.c | 12 +++----
 2 files changed, 94 insertions(+), 7 deletions(-)

-- 
1.9.1.423.g4596e3a

