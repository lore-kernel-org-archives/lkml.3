Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaARIcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 03:32:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaARIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 03:32:28 -0500
Date: Sat, 18 Jan 2014 00:34:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Branimir Maksimovic <branimir.maksimovic@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vm commit in atop utility steadilly grows (latest mainline
 kernel from git)
Message-Id: <20140118003448.5b2b0e6d.akpm@linux-foundation.org>
In-Reply-To: <52D97F2D.1020500@gmail.com>
References: <52D97F2D.1020500@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jan 2014 20:06:21 +0100 Branimir Maksimovic <branimir.maksimovic@gmail.com> wrote:

> Yesterday, I have noticed that vmcom steadilly grows (it was 7TB before
> I noticed). I compile kernel every day or two after git pull.
> Rebooted and then watched atop, vmcom constantly grows.
> Didn't notice any of running processes to allocate.
> Booted in 3.12.8 kernel and everything is back to normal.
> Since this is pretty noticable, I guess that this is caused by commit
> between rc8 release and now, not sure.
> Machine is i5 3570k, motherboard asus maximus gene v.
> 

I expect this was fixed by 

commit d1969a84dd6a44d375aa82bba7d6c38713a429c3
Author: Hugh Dickins <hughd@google.com>
Date:   Thu Jan 16 15:26:48 2014 -0800

    percpu_counter: unbreak __percpu_counter_add()

