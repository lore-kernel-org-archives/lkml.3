Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbaJZEbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 00:31:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaJZEbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 00:31:47 -0400
Date: Sat, 25 Oct 2014 21:32:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: UKSM: What's maintainers think about it?
Message-Id: <20141025213201.005762f9.akpm@linux-foundation.org>
In-Reply-To: <CAGqmi77uR2Nems6fE_XM1t3a06OwuqJP-0yOMOQh7KH13vzdzw@mail.gmail.com>
References: <CAGqmi77uR2Nems6fE_XM1t3a06OwuqJP-0yOMOQh7KH13vzdzw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014 22:25:56 +0300 Timofey Titovets <nefelim4ag@gmail.com> wrote:

> Good time of day, people.
> I try to find 'mm' subsystem specific people and lists, but list
> linux-mm looks dead and mail archive look like deprecated.
> If i must to sent this message to another list or add CC people, let me know.

linux-mm@kvack.org is alive and well.

> If questions are already asked (i can't find activity before), feel
> free to kick me.
> 
> The main questions:
> 1. Somebody test it? I see many reviews about it.
> I already port it to latest linux-next-git kernel and its work without issues.
> http://pastebin.com/6FMuKagS
> (if it matter, i can describe use cases and results, if somebody ask it)
> 
> 2. Developers of UKSM already tried to merge it? Somebody talked with uksm devs?
> offtop: now i try to communicate with dev's on kerneldedup.org forum,
> but i have problems with email verification and wait admin
> registration approval.
> (i already sent questions to
> http://kerneldedup.org/forum/home.php?mod=space&username=xianai ,
> because him looks like team leader)
> 
> 3. I just want collect feedbacks from linux maintainers team, if you
> decide what UKSM not needed in kernel, all other comments (as i
> understand) not matter.
> 
> Like KSM, but better.
> UKSM - Ultra Kernel Samepage Merging
> http://kerneldedup.org/en/projects/uksm/introduction/

It's the first I've heard of it.  No, as far as I know there has been
no attempt to upstream UKSM.

