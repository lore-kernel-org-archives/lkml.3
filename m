Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab3BUWSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:18:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3BUWSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:18:43 -0500
Date: Thu, 21 Feb 2013 14:18:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Steven Rostedt <rostedt@goodmis.org>, u3557@dialix.com.au,
        Oleg Nesterov <oleg@redhat.com>, Pedro Alves <palves@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: prctl(PR_SET_MM)
Message-Id: <20130221141841.c760b02f.akpm@linux-foundation.org>
In-Reply-To: <20130221080028.GE1740@moon>
References: <20130220105109.GW20312@moon>
	<20130221074639.4880D592064@miso.sublimeip.com>
	<20130221080028.GE1740@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013 12:00:28 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> From: Amnon Shiloh <u3557@miso.sublimeip.com>
> Subject: prctl: Make PR_SET_MM being depend on own CONFIG_MM_FIELDS_SETTING
> 
> ...
> 
> Signed-off-by: Amnon Shiloh <u3557@miso.sublimeip.com>

The "..." makes me sad.

If/when this patch gets sent for real, please explain the reasons? 
AFAICT it permits the enabling of prctl(PR_SET_MM) in
CONFIG_CHECKPOINT_RESTORE=n kernels.  If that was indeed the intent,
why?

