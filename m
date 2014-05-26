Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaEZODP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:03:15 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64841 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaEZODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:03:13 -0400
Message-ID: <1401112989.23186.28.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org
Date: Mon, 26 May 2014 16:03:09 +0200
In-Reply-To: <53832A36.5020205@huawei.com>
References: <5382AF2E.1040407@huawei.com>
	 <1401090987.5339.79.camel@marge.simpson.net> <53832A36.5020205@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 19:49 +0800, Libo Chen wrote:

> how to turn off SD_SHARE_PKG_RESOURCES in userspace ?

I use a script Ingo gave me years and years ago to
twiddle /proc/sys/kernel/sched_domain/cpuN/domainN/flags domain wise.
Doing that won't do you any good without a handler to build/tear down
sd_llc when you poke at flags though.  You can easily add a sched
feature to play with it.

-Mike

