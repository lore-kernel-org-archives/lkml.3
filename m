Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3JARcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:32:03 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41276 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3JARcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:32:01 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: tabloid.adroit@gmail.com
Date: Tue, 1 Oct 2013 13:32:00 -0400
X-Google-Sender-Auth: dhfA8hJcONsOvALn9NXqopIVFIQ
Message-ID: <CAJh9x3oMz7FMOv+_hxo=sPAYmB_Ks7AWBLjGW+QNKm-aNY459Q@mail.gmail.com>
Subject: measure uncore events
From: Yuanfang Chen <cyfmxc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm trying to measure uncore events. After reading [1], I tried "perf
stat -a -e "uncore_imc_0/event=0xff,umask=0x00/" /bin/ls", it says
"invalid or unsupported event".

The machine is Intel Ivy Bridge i5-3320M with ArchLinux 3.11.2-1-ARCH.
'perf --version'  is 'perf version 3.11.0'
In '/sys/bus/event_source/devices/uncore_cbox_0/events', there is only
one event 'clockticks'.

Did I miss something?

thanks,
yuanfang


[1] http://web.eece.maine.edu/~vweaver/projects/perf_events/faq.html#q1c
