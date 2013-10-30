Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3J3UUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:20:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3J3UUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:20:52 -0400
Date: Wed, 30 Oct 2013 21:20:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4 6/7] events: use get_unused_fd_flags(0) instead of
 get_unused_fd()
Message-ID: <20131030202041.GS16117@laptop.programming.kicks-ass.net>
References: <cover.1383121137.git.ydroneaud@opteya.com>
 <3b0bc009ff1410d04f8a1e71bfae0d27e1254b90.1383121137.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b0bc009ff1410d04f8a1e71bfae0d27e1254b90.1383121137.git.ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 08:47:46PM +0100, Yann Droneaud wrote:
> This patch replaces calls to get_unused_fd() with equivalent call to
> get_unused_fd_flags(0) to preserve current behavor for existing code.
> 
> The hard coded flag value (0) should be reviewed on a per-subsystem basis,
> and, if possible, set to O_CLOEXEC.

And how am I supposed to know if that is 'possible'? You provide a total
number of 0 useful clues on how to determine this.


