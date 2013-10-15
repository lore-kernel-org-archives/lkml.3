Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab3JORWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:22:48 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:60647 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932396Ab3JORWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:22:47 -0400
Date: Tue, 15 Oct 2013 17:22:45 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Toshi Kani <toshi.kani@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 1/2] mm: Set N_CPU to node_states during boot
In-Reply-To: <1381857176-22999-2-git-send-email-toshi.kani@hp.com>
Message-ID: <00000141bd24292a-c0ebad11-c3bb-441e-a58e-e17b3bc2e21c-000000@email.amazonses.com>
References: <1381857176-22999-1-git-send-email-toshi.kani@hp.com> <1381857176-22999-2-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.15-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Toshi Kani wrote:

> Changed setup_vmstat() to mark N_CPU to the nodes with
> online CPUs at boot, which is consistent with other
> operations in vmstat_cpuup_callback(), i.e. start_cpu_timer()
> and refresh_zone_stat_thresholds().

Acked-by: Christoph Lameter <cl@linux.com>

