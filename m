Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaBEVbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:31:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:58077 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753686AbaBEVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:31:41 -0500
Date: Wed, 5 Feb 2014 16:31:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
Message-ID: <20140205163138.51eb8b31@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1402051324370.14325@chino.kir.corp.google.com>
References: <52F1F25F.20402@parallels.com>
	<1391588133-15469-1-git-send-email-vdavydov@parallels.com>
	<20140205195837.GA6857@home.goodmis.org>
	<alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com>
	<20140205155840.43d6b4ad@gandalf.local.home>
	<alpine.DEB.2.02.1402051301460.14325@chino.kir.corp.google.com>
	<20140205161952.781e3a0e@gandalf.local.home>
	<alpine.DEB.2.02.1402051324370.14325@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 13:25:28 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:
 
> Looks like you've got something prepared already!  Mind sending it to 
> Pekka as a patch based on linux-next?

Sure, and there's another lockdep splat that I'm working on too.

But first, I need to shovel my driveway yet again (We got something
like 18 inches of snow in the last 24 hours).

-- Steve

