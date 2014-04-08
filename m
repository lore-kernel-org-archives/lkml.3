Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbaDHPm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:42:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:43801 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757459AbaDHPmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:42:25 -0400
Date: Tue, 8 Apr 2014 11:42:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Lam <azl@google.com>
Subject: Re: [for-next][PATCH 14/14] tracing: Get trace_array ref counts
 when accessing trace files
Message-ID: <20140408114223.753bd633@gandalf.local.home>
In-Reply-To: <53406181.70805@oracle.com>
References: <20130702202216.623562799@goodmis.org>
	<20130702202427.455930200@goodmis.org>
	<53401A3E.2090302@oracle.com>
	<20140405143326.7c38ff91@gandalf.local.home>
	<53406181.70805@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Apr 2014 16:03:13 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:
 
> > Thanks for the update. I run all my tests with lockdep enabled. I'm
> > wondering if your config enable a lock that I don't have in my configs.
> > Could you send me your .config please.
> 
> Attached.
> 

Do you have any other configs that trigger this? This config is a
monster and after I finally did get it to install, it just locked up on
boot, with no messages.

-- Steve
