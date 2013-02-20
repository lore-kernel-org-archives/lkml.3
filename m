Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab3BTIkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:40:04 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62384 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3BTIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:40:02 -0500
Date: Wed, 20 Feb 2013 12:39:58 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, u3557@dialix.com.au,
        Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: prctl(PR_SET_MM)
Message-ID: <20130220083958.GS20312@moon>
References: <1361216963.23152.168.camel@gandalf.local.home>
 <20130219062531.4F317592076@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219062531.4F317592076@miso.sublimeip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 05:25:31PM +1100, Amnon Shiloh wrote:
> 
> To reconstruct Linux process(es), one must be able to restore all their
> memory contents, states and registers to their original and consistent
> values.

I personally don't mind if this come become y by default, because it will
work for us. Still I guess if you need to reconstruct Linux process(es)
plain prctl extension is not enough, you still need a functionality which
is enclosed in config-checkpoint-restore (say /proc/pid/map_files, kcmp),
no?
