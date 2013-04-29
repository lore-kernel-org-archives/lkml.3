Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3D2P45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:56:57 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:65155 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab3D2P4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:56:55 -0400
Date: Mon, 29 Apr 2013 17:56:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ptrace/x86: introduce ptrace_register_breakpoint()
Message-ID: <20130429155648.GA31230@somewhere>
References: <20130418184350.GA4407@redhat.com>
 <20130418184417.GA4439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184417.GA4439@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:44:17PM +0200, Oleg Nesterov wrote:
> No functional changes, preparation.
> 
> Extract the "register breakpoint" code from ptrace_get_debugreg()
> into the new/generic helper, ptrace_register_breakpoint(). It will
> have more users.
> 
> The patch also adds another simple helper, ptrace_fill_bp_fields(),
> to factor out the arch_bp_generic_fields() logic in register/modify.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
