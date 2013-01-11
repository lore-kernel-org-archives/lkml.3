Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3AKBah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:30:37 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:36154 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3AKBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:30:36 -0500
MIME-Version: 1.0
In-Reply-To: <1356434680-10045-1-git-send-email-festevam@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
Date: Thu, 10 Jan 2013 23:30:35 -0200
Message-ID: <CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Fix print format for u64
From: Fabio Estevam <festevam@gmail.com>
To: mingo@redhat.com
Cc: peterz@infradead.org, pjt@google.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Dec 25, 2012 at 9:24 AM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> commit c566e8e9 (sched: Aggregate total task_group load) introduced the
> following build warning:
>
> kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Wformat]
> kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'u64' [-Wformat]
>
> Use %llu format to print a u64 value as per Documentation/printk-formats.txt.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Does this one look good?

Regards,

Fabio Estevam
