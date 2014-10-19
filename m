Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaJSXZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:25:53 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:60004 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaJSXZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:25:50 -0400
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com> <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com> <20141019210348.GA28144@drone.musicnaut.iki.fi> <CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <92A2706E-B03D-4349-B271-CD7FD2FF7ED0@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (12A365)
From: pinskia@gmail.com
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
Date: Sun, 19 Oct 2014 16:25:49 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





> On Oct 19, 2014, at 4:05 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Sun, Oct 19, 2014 at 2:03 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
>> 
>> Here's one example how it fails: http://marc.info/?l=gcc&m=141349914632010&w=2
> 
> Ok, that just looks like a gnu11 bug, then. Not being able to
> initialize structures because some sub-structure has a volatile member
> is just pure BS.
> 
> Has anybody reported this as a gcc bug? That email may be on the gcc
> list, but I'm not seeing anybody acknowledge it as a bug..

Yes it was reported and both problems relating to this extension has been added to gnu99 and gnu11. Though there are other issues with the kernel dealing with extern inline have different semantics between gnu89 and gnu99/11. 

Thanks,
Andrew

> 
> I cannot imagine that anybody sane claims that this is *wanted*
> behavior from "gnu11".
> 
>                       Linus
