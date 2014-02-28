Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaB1PAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:00:05 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44083 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaB1PAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:00:03 -0500
MIME-Version: 1.0
Date: Fri, 28 Feb 2014 16:00:02 +0100
Message-ID: <CAOihqkJ+aap=zZk0gjax9yfqqVa-1jR+Zf0BMjGi57A0CWquAA@mail.gmail.com>
Subject: Is it possible to get deterministic system with 3.10.xx and Full-RT-preemption?
From: Andreas Starzer <stzlinux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a possible configuration/implementation at Kernel 3.10.xx
with PREEMPT_RT_FULL=y (or newer) to get an explicit thread for
workqueues which do exclusive work?

I want to increase the priority of my drivers workqueue (and only
this) to be still functional under heavy system load like
network-flood for example.

I tried explicit kthread-worker creation, but it behaves same as
workqueue implementation.
