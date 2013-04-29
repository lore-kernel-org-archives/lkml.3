Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3D2SDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:03:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42982 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3D2SDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:03:34 -0400
Date: Mon, 29 Apr 2013 11:03:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [STABLE] tracing: Fix selftest function recursion accounting
Message-ID: <20130429180331.GA30893@kroah.com>
References: <1366897812.10248.15.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366897812.10248.15.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 09:50:12AM -0400, Steven Rostedt wrote:
> Greg,
> 
> Can you add this to the 3.8 stable tree. It's not applicable for earlier
> kernels.
> 
> Thanks!
> 
> -- Steve
> 
> commit 05cbbf643b8eea1be21082c53cdb856d1dc6d765
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Jan 22 23:35:11 2013 -0500
> 
>     tracing: Fix selftest function recursion accounting

Now applied, thanks.

greg k-h
