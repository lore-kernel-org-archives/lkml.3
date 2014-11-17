Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaKQUdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:33:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64975 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541AbaKQUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:33:18 -0500
Date: Mon, 17 Nov 2014 15:33:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 47/56] kenel/trace: support compiling out splice
Message-ID: <20141117153315.3ce0439b@gandalf.local.home>
In-Reply-To: <1415913813-362-48-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
	<1415913813-362-1-git-send-email-pieter@boesman.nl>
	<1415913813-362-48-git-send-email-pieter@boesman.nl>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 22:23:24 +0100
Pieter Smith <pieter@boesman.nl> wrote:

> Compile out splice support from trace when the splice-family of syscalls is not
> supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

The tracing code is a hell of a lot bigger than the splice code. If you
are doing this to save space, then simply make the tracing code select
SYSCALL_SPLICE, and leave the rest of the #ifdef out.

Thanks,

-- Steve

