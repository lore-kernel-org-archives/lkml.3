Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaBFA6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:58:01 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62429 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaBFA57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140205.162747.1987151373519827206.davem@redhat.com>
References: <1391645407-4092-1-git-send-email-ast@plumgrid.com>
	<20140205.162747.1987151373519827206.davem@redhat.com>
Date: Wed, 5 Feb 2014 16:57:56 -0800
Message-ID: <CAMEtUuw_uiqY+qJbdb49gh9xb40vZHAEbD2V=Qg8W_ZNanu+eg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 tip 0/7] 64-bit BPF insn set and tracing filters
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@redhat.com>
Cc: mingo@kernel.org, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        hpa@zytor.com, tglx@linutronix.de, masami.hiramatsu.pt@hitachi.com,
        tom.zanussi@linux.intel.com, jovi.zhangwei@gmail.com,
        Eric Dumazet <edumazet@google.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, fweisbec@gmail.com, acme@infradead.org,
        penberg@iki.fi, arjan@infradead.org, hch@infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 4:27 PM, David Miller <davem@redhat.com> wrote:
>
> From: Alexei Starovoitov <ast@plumgrid.com>
> Date: Wed,  5 Feb 2014 16:10:00 -0800
>
> > this patch set addresses main sticking points of the previous discussion:
> > http://thread.gmane.org/gmane.linux.kernel/1605783
>
> You really need to properly CC: netdev on this patch series.

Sure. Happy to extend the audience.
Will repost with netdev included.
