Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3JORj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:39:29 -0400
Received: from a14-6.smtp-out.amazonses.com ([54.240.14.6]:57790 "EHLO
	a14-6.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932287Ab3JORj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:39:28 -0400
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2013 13:39:28 EDT
Date: Tue, 15 Oct 2013 17:23:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Toshi Kani <toshi.kani@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 2/2] mm: Clear N_CPU from node_states at CPU offline
In-Reply-To: <1381857176-22999-3-git-send-email-toshi.kani@hp.com>
Message-ID: <00000141bd246468-e388da5e-d7ba-4428-9374-9b37ca59b92c-000000@email.amazonses.com>
References: <1381857176-22999-1-git-send-email-toshi.kani@hp.com> <1381857176-22999-3-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.15-54.240.14.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Toshi Kani wrote:

> vmstat_cpuup_callback() is a CPU notifier callback, which
> marks N_CPU to a node at CPU online event.  However, it
> does not update this N_CPU info at CPU offline event.

Acked-by: Christoph Lameter <cl@linux.com>
