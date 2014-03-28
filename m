Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaC1QHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:07:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaC1QHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:07:00 -0400
Date: Fri, 28 Mar 2014 09:08:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
Message-ID: <20140328160853.GB1041@kroah.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 09:47:21AM -0400, Jovi Zhangwei wrote:
> Hi All,
> 
> The following set of patches add ktap tracing tool. 

Yeah!

Thanks for putting this patch set together, it looks good.

But, why hide the kernel portions of ktap in the tools/ directory?  Is
that ok with everyone else?  I don't expect to see kernel code burried
in that directory, so any kernel API changes that might happen, might
not get propagated into that location.

thanks,

greg k-h
