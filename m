Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaICSGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:06:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaICSGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:06:04 -0400
Date: Wed, 3 Sep 2014 11:06:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>
Subject: Re: mm: kernel BUG at mm/mmap.c:446!
Message-Id: <20140903110602.a369cc8efaab5c55b66e8a42@linux-foundation.org>
In-Reply-To: <54074EB9.4000301@oracle.com>
References: <54074EB9.4000301@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014 13:24:09 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:
> 
> [ 8419.384997] kernel BUG at mm/mmap.c:446!
> 
> ...
>
> I'm not sure which one of the possible reasons for BUG() it was since the
> pr_info didn't end up getting printed

grr.

> (I'm sending a patch to make that code nicer).

pr_emerg(), please.
