Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab3HNWO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:14:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170Ab3HNWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:14:57 -0400
Date: Wed, 14 Aug 2013 15:14:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: dilinger@queued.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] olpc-ec: initialise earlier
Message-Id: <20130814151454.76650feb7f8095dabb1cf691@linux-foundation.org>
In-Reply-To: <20130810192215.B83A2FAB04@dev.laptop.org>
References: <20130810192215.B83A2FAB04@dev.laptop.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013 15:22:15 -0400 (EDT) Daniel Drake <dsd@laptop.org> wrote:

> Being a low-level component, various drivers (e.g. olpc-battery) assume that
> it is ok to communicate with the OLPC Embedded Controller during probe.
> Therefore the OLPC EC driver must be initialised before other drivers try to
> use it. This was the case until it was recently moved out of arch/x86 and
> restructured.
> 
> Use arch_initcall so that olpc-ec is readied earlier, matching the
> previous behaviour. Fixes various drivers such as olpc-battery and
> olpc-xo1-sci.
> 

You imply that there was a regression, but don't describe the
user-visible effects of the regression.

You provide hints which would permit me, with sufficient effort, to
approximately work out which kernel versions were affected by the
regression and then left it at that.

I need to work out which kernel version(s) need patching, and why. 
Please, make it easier for me!

