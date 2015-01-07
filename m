Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbbAGVg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:36:29 -0500
Received: from mail-ig0-f195.google.com ([209.85.213.195]:47750 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbbAGVg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:36:28 -0500
MIME-Version: 1.0
Date: Wed, 7 Jan 2015 16:36:27 -0500
Message-ID: <CAH86sK+0fMKpkRAkPOt_oXGynhi6605w1acxWyXqywP3Cs4TTg@mail.gmail.com>
Subject: sched_yield() call on Linux Kernel 2.6.39 is not behaving correctly
From: Yogesh Ahire <yogesh02061983@gmail.com>
To: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have a system with multiple CPU cores.  I have multiple threads
assigned to particular CPU. Among these threads the main thread calls
sched_yield() if it has nothing to do, I am hoping that doing so will
give chance to other threads to run. But the strange behavior of
sched_yield() is , even if there are ready-to-runs tasks on this CPU
waiting for their turn, the task which calls sched_yield() is always
running ( get scheduled) and not giving chance to any other task to
run. It is consuming 100% of CPU. Is sched_yield() is broken on 2.6
Kernel?


Thanks
Yogesh
