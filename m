Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab3JOR3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:29:19 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46989 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab3JOR3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:29:17 -0400
Message-ID: <1381857934.26234.99.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/2] mm: Set N_CPU to node_states during boot
From: Toshi Kani <toshi.kani@hp.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com
Date: Tue, 15 Oct 2013 11:25:34 -0600
In-Reply-To: <00000141bd24292a-c0ebad11-c3bb-441e-a58e-e17b3bc2e21c-000000@email.amazonses.com>
References: <1381857176-22999-1-git-send-email-toshi.kani@hp.com>
	 <1381857176-22999-2-git-send-email-toshi.kani@hp.com>
	 <00000141bd24292a-c0ebad11-c3bb-441e-a58e-e17b3bc2e21c-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 17:22 +0000, Christoph Lameter wrote:
> On Tue, 15 Oct 2013, Toshi Kani wrote:
> 
> > Changed setup_vmstat() to mark N_CPU to the nodes with
> > online CPUs at boot, which is consistent with other
> > operations in vmstat_cpuup_callback(), i.e. start_cpu_timer()
> > and refresh_zone_stat_thresholds().
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Thanks Christoph for the quick review to the patchset!
-Toshi

