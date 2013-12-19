Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab3LSTy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:54:58 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:55292 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab3LSTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:54:56 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: masami.hiramatsu.pt@hitachi.com, tom.zanussi@linux.intel.com,
        gnurou@gmail.com
Cc: rostedt@goodmis.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2] Tracing events with GPIOs
Date: Thu, 19 Dec 2013 20:54:35 +0100
Message-Id: <1387482876-17454-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the advice of Masami, I implemented the GPIO trace on top of the event
triggers (git://git.yoctoproject.org/linux-yocto-contrib
tzanussi/event-triggers-v11)

Alexandre,
This version uses the old gpio API (i-e gpio identifed by integers). GPIOs are
not requested in this patch, allowing any gpio to be used as a probe. It's a bit
dangerous but I think it's okay for the moment. When this patch is adapted to the
gpio descriptor API, we'll have to find a way to request the gpio properly.

Jean-Jacques Hiblot (1):
  Tracing events with GPIOs

 include/linux/ftrace_event.h        |   1 +
 kernel/trace/trace_events_trigger.c | 285 ++++++++++++++++++++++++++++++++++++
 2 files changed, 286 insertions(+)

-- 
1.8.3.1

