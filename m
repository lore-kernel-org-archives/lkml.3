Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaEVMVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:21:49 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44782 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbaEVMVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:21:47 -0400
Date: Thu, 22 May 2014 14:21:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: delete unused variable tmp to fix new build warning
Message-ID: <20140522122142.GA6650@gmail.com>
References: <1400700787-11759-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400700787-11759-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> commit 3a497f48637e2aac17eabb84a17f8ac5216028fc [tip:perf/core]
> ("perf: Simplify perf_event_exit_task_context()") deleted the
> code that was using tmp but not the declaration of it, causing:
> 
> kernel/events/core.c:7434:35: warning: unused variable ‘tmp’ [-Wunused-variable]

This warning should be addressed by:

  12665b35b0b4 perf/events/core: Drop unused variable after cleanup

Thanks,

	Ingo
