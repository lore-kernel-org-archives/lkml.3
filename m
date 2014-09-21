Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaIUHFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 03:05:30 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33353 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaIUHF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 03:05:29 -0400
Date: Sun, 21 Sep 2014 09:05:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/3] x86, ptdump: Simplify page flag evaluation code
Message-ID: <20140921070524.GA10827@gmail.com>
References: <1411248142-28951-1-git-send-email-minipli@googlemail.com>
 <1411248142-28951-3-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411248142-28951-3-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathias Krause <minipli@googlemail.com> wrote:

> -#define pt_dump_seq_printf(m, to_dmesg, fmt, args...)		\
> +#define ptd_print(m, to_dmesg, fmt, args...)			\

Please don't abbreviate to non-obvious shortcuts ('ptd'), keep 
using the pt_dump_ prefix which was just fine.

(If checkpatch complains about lines slightly above 80cols then 
ignore checkpatch, don't uglify the code.)

Thanks,

	Ingo
