Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaBIVfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:35:55 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:65400 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaBIVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:35:54 -0500
Date: Sun, 9 Feb 2014 13:35:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: tglx@linutronix.de, fengguang.wu@intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time/cpuidle:Fixup fallout from hrtimer broadcast mode
 inclusion
In-Reply-To: <52F752AF.7000805@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1402091326020.5688@chino.kir.corp.google.com>
References: <20140207172924.8248.55002.stgit@preeti> <alpine.DEB.2.02.1402082329410.8686@chino.kir.corp.google.com> <52F752AF.7000805@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Feb 2014, Preeti U Murthy wrote:

> Hi David,
> 
> I have sent out a revised patch on
> https://lkml.org/lkml/2014/2/9/2. Can you let me
> know if this works for you?
> 

This is commit 849401b66d30 ("tick: Fixup more fallout from hrtimer 
broadcast mode") in timers/core and it fixes it for my config.
