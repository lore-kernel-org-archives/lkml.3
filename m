Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3D2QAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:00:45 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51131 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3D2QAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:00:43 -0400
Date: Mon, 29 Apr 2013 18:00:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] ptrace/x86: cleanup ptrace_set_debugreg()
Message-ID: <20130429160038.GC31230@somewhere>
References: <20130418184350.GA4407@redhat.com>
 <20130418184422.GA4447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184422.GA4447@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:44:22PM +0200, Oleg Nesterov wrote:
> ptrace_set_debugreg() is trivial but looks horrible. Kill the
> unnecessary goto's and return's to cleanup the code.
> 
> This matches ptrace_get_debugreg() which also needs the trivial
> whitespace cleanups.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
