Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbaGAXgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 19:36:00 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45497 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaGAXf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 19:35:59 -0400
Date: Tue, 1 Jul 2014 16:35:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jerome Marchand <jmarchan@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: make copy_pte_range static again
In-Reply-To: <1404202674-11648-1-git-send-email-jmarchan@redhat.com>
Message-ID: <alpine.DEB.2.02.1407011635440.15139@chino.kir.corp.google.com>
References: <1404202674-11648-1-git-send-email-jmarchan@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Jerome Marchand wrote:

> Commit 71e3aac (thp: transparent hugepage core) adds copy_pte_range
> prototype to huge_mm.h. I'm not sure why (or if) this function have
> been used outside of memory.c, but it currently isn't.
> This patch makes copy_pte_range() static again.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
