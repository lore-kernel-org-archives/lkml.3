Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbaGXOvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:51:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:17420 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932975AbaGXOvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:51:40 -0400
Date: Thu, 24 Jul 2014 10:51:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, john.stultz@linaro.org,
        paul.gortmaker@windriver.com, gang.chen.5i5j@gmail.com,
        yongjun_wei@trendmicro.com.cn, dan.carpenter@oracle.com,
        tomas.winkler@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
Message-ID: <20140724105132.3cf221c2@gandalf.local.home>
In-Reply-To: <20140724144725.GA32669@home.goodmis.org>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
	<20140724144725.GA32669@home.goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014 10:47:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

 
> The three parameters are the number of elements, the size of each individual
> element, and then finally the flags used on how to allocate that memory.
> I have to say, you did get the flags part correct.
> 
> Now lets look at what you did. For the size you had:

That should have read "For the count you had:"

Oh well, you get my point anyway.

-- Steve

> 
>   *dummy_ion_ptr.nr
> 
