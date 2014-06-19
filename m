Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbaFSRGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:06:03 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46974 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbaFSRGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:06:00 -0400
Message-ID: <1403197556.4872.21.camel@marge.simpson.net>
Subject: Re: How to disable Lazy Preempt in the kernel
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: tdjames <tdjames@umd.edu>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 19:05:56 +0200
In-Reply-To: <1403192952555-885031.post@n7.nabble.com>
References: <1403190681610-885003.post@n7.nabble.com>
	 <20140619153555.GA1740@fancy-poultry.org>
	 <1403192952555-885031.post@n7.nabble.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 08:49 -0700, tdjames wrote: 
> When I use 
> echo NO_PREEMPT_LAZY >/sys/kernel/debug/sched_features
> (as root), I get the following error:
> 
> bash: echo: write error: Invalid argument
> 
> How do I get past this?  Thanks

Easy, do.. nothing.  (it's build-time disabled on x86_64;)

-Mike


