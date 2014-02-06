Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaBFA2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:28:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbaBFA2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:28:41 -0500
Date: Wed, 05 Feb 2014 16:27:47 -0800 (PST)
Message-Id: <20140205.162747.1987151373519827206.davem@redhat.com>
To: ast@plumgrid.com
Cc: mingo@kernel.org, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        hpa@zytor.com, tglx@linutronix.de, masami.hiramatsu.pt@hitachi.com,
        tom.zanussi@linux.intel.com, jovi.zhangwei@gmail.com,
        edumazet@google.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, fweisbec@gmail.com, acme@infradead.org,
        penberg@iki.fi, arjan@infradead.org, hch@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 tip 0/7] 64-bit BPF insn set and tracing filters
From: David Miller <davem@redhat.com>
In-Reply-To: <1391645407-4092-1-git-send-email-ast@plumgrid.com>
References: <1391645407-4092-1-git-send-email-ast@plumgrid.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed,  5 Feb 2014 16:10:00 -0800

> this patch set addresses main sticking points of the previous discussion:
> http://thread.gmane.org/gmane.linux.kernel/1605783

You really need to properly CC: netdev on this patch series.
