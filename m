Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaIJSbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:31:03 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:41947 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaIJSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:31:01 -0400
MIME-Version: 1.0
In-Reply-To: <1410367910-6026-7-git-send-email-toshi.kani@hp.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com> <1410367910-6026-7-git-send-email-toshi.kani@hp.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 10 Sep 2014 11:30:40 -0700
Message-ID: <CALCETrVnHg0X=R23qyiPtxYs3knHaXq65L0Jw_1oY4=gX5kpXQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] x86, pat: Update documentation for WT changes
To: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 9:51 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> +Drivers may map the entire NV-DIMM range with ioremap_cache and then change
> +a specific range to wt with set_memory_wt.

That's mighty specific :)

It's also not all that informative.  Are you supposed to set the
memory back before iounmapping?  Can you do this with set_memory_wc on
an uncached mapping?

--Andy
