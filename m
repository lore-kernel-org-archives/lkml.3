Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaFCKEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:04:22 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:44095 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaFCKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <538cec44.jI+55ebacSdevas2%akpm@linux-foundation.org>
References: <538cec44.jI+55ebacSdevas2%akpm@linux-foundation.org>
Date: Tue, 3 Jun 2014 13:04:20 +0300
Message-ID: <CACVxJT_q+Wb69xZOT_NCG6z7A6AxaFS6i9GGk3-GStOESBvPww@mail.gmail.com>
Subject: Re: + fs-proc-consoles-replace-seq_printf-by-seq_puts.patch added to
 -mm tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, fabf@skynet.be,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 12:27 AM,  <akpm@linux-foundation.org> wrote:
> -       seq_printf(m, "\n");
> +       seq_puts(m, "\n");

It should be set_putc.

Convert all fs/proc in one patch, there is no reason to split.
