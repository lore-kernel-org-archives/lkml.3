Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3DPADV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:03:21 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:51331 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3DPADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:03:20 -0400
Date: Tue, 16 Apr 2013 02:03:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ptrace/x86: simplify the "disable" logic in
 ptrace_write_dr7()
Message-ID: <20130416000314.GF17561@somewhere.redhat.com>
References: <20130414191205.GA28791@redhat.com>
 <20130414191228.GA28809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414191228.GA28809@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 09:12:28PM +0200, Oleg Nesterov wrote:
> ptrace_write_dr7() looks unnecessarily overcomplicated. We can
> factor out ptrace_modify_breakpoint() and do not do "continue"
> twice, just we need to pass the proper "disabled" argument to
> ptrace_modify_breakpoint().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
