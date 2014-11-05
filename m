Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaKENuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:50:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaKENuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:50:18 -0500
Message-ID: <545A2B18.1080101@suse.cz>
Date: Wed, 05 Nov 2014 14:50:16 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-perf-users@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: perf top out of bounds address warnings when zoomed to kernel DSO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when running perf top, immediately after zooming into kernel DSO I start getting
tons of warnings like these, always for some userspace binary:

┌─Warning:────────────────────────────────────────┐
│Out of bounds address found:                     │
│                                                 │
│Addr:   5d558                                    │
│DSO:    /bin/bash f                              │
│Map:    400000-4ab000                            │
│Symbol: 5d4e0-5d4ef g malloc@plt                 │
│Arch:   x86_64                                   │
│Kernel: 3.18.0-rc3                               │
│Tools:  3.17.2                                   │
│                                                 │
│Not all samples will be on the annotation output.│
│                                                 │
│Please report to linux-kernel@vger.kernel.org    │
│                                                 │
│                                                 │
│Press any key...                                 │
└─────────────────────────────────────────────────┘

Vlastimil
