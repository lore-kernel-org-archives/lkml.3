Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaDESde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 14:33:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:47915 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753319AbaDESdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 14:33:33 -0400
Date: Sat, 5 Apr 2014 14:33:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Lam <azl@google.com>
Subject: Re: [for-next][PATCH 14/14] tracing: Get trace_array ref counts
 when accessing trace files
Message-ID: <20140405143326.7c38ff91@gandalf.local.home>
In-Reply-To: <53401A3E.2090302@oracle.com>
References: <20130702202216.623562799@goodmis.org>
	<20130702202427.455930200@goodmis.org>
	<53401A3E.2090302@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Apr 2014 10:59:10 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 07/02/2013 04:22 PM, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > When a trace file is opened that may access a trace array, it must
> > increment its ref count to prevent it from being deleted.
> > 
> > Cc: stable@vger.kernel.org # 3.10
> > Reported-by: Alexander Lam <azl@google.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Hi Steven,
> 
> This patch seems to cause the following lockdep warning:
> 

Thanks for the update. I run all my tests with lockdep enabled. I'm
wondering if your config enable a lock that I don't have in my configs.
Could you send me your .config please.

Thanks!

-- Steve
