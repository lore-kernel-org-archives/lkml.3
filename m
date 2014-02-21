Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaBUUTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:19:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaBUUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:19:46 -0500
Date: Fri, 21 Feb 2014 12:19:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@kernel.org>,
        Jan Beulich <jbeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + makefile-fix-build-with-make-380-again.patch added to -mm
 tree
Message-Id: <20140221121944.bb80827b15aa616b07a56912@linux-foundation.org>
In-Reply-To: <CAGXu5jJrTdD9GzbbSLQbbJJV1=XZbJ6sLpZR3q6mt1OzM8fM6w@mail.gmail.com>
References: <5307b218.8VLijuWgRh9icTUZ%akpm@linux-foundation.org>
	<CAGXu5jJrTdD9GzbbSLQbbJJV1=XZbJ6sLpZR3q6mt1OzM8fM6w@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 12:09:51 -0800 Kees Cook <keescook@chromium.org> wrote:

> 
> This appears to be missing the:
> 
> -else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
> +else
> +ifdef CONFIG_CC_STACKPROTECTOR_STRONG
> 
> chunk?

Yup, already fixed after my kernel wouldn't compile ;)

It conflicted with
makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled.patch
and I mucked up the repairs.
