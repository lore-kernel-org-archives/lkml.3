Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422757AbaD3UQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:16:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422664AbaD3UQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:16:18 -0400
Date: Wed, 30 Apr 2014 13:16:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] ptrace: Fix fork event messages across pid
 namespaces
Message-Id: <20140430131616.32899e2dc4f0592c9cd21075@linux-foundation.org>
In-Reply-To: <1398818077-25107-1-git-send-email-mdempsky@chromium.org>
References: <1398802858-13624-1-git-send-email-mdempsky@chromium.org>
	<1398818077-25107-1-git-send-email-mdempsky@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 17:34:37 -0700 Matthew Dempsky <mdempsky@chromium.org> wrote:

> On Tue, Apr 29, 2014 at 3:11 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > More Oleg review would be nice, please ;)
> 
> FWIW, Oleg "acked" v4 earlier in the thread.  Are you asking for
> further review from him beyond that?

It's conventional to retain acked-by's and reviewed-by's in the
changelog.  Sometimes they can be invalidated by subsequent changes -
that's a judgement call one has to make.


