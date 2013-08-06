Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3HFBlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:41:44 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59324 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3HFBln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:41:43 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/5] perf kvm live - latest round take 4
Date: Mon,  5 Aug 2013 21:41:32 -0400
Message-Id: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

This round addresses all of Xiao's comments. It also includes a small
change in the live mode introduction to improve ordered samples
processing. For that a change in perf-session functions is needed.

David Ahern (5):
  perf session: Export queue_event function
  perf kvm: add live mode - v4
  perf kvm: add min and max stats to display - v2
  perf kvm: option to print events that exceed a threshold
  perf kvm stat report: Add option to analyze specific VM

 tools/perf/builtin-kvm.c  |  725 +++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/perf.h         |    3 +
 tools/perf/util/session.c |   10 +-
 tools/perf/util/session.h |    6 +-
 4 files changed, 708 insertions(+), 36 deletions(-)

-- 
1.7.10.1

