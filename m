Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaHKSxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:53:46 -0400
Received: from mail.tmr.com ([64.65.253.246]:59107 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753822AbaHKSxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:53:45 -0400
Message-ID: <53E90BCF.3030004@tmr.com>
Date: Mon, 11 Aug 2014 14:30:39 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120715 Firefox/14.0.1 SeaMonkey/2.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: iSCSI target stops sending responses to login requests
References: <CAHjPQwNFr5gA-vcQa0nk98U0yPgEdCj+iXWeP0_mXpjXdrW+sA@mail.gmail.com>
In-Reply-To: <CAHjPQwNFr5gA-vcQa0nk98U0yPgEdCj+iXWeP0_mXpjXdrW+sA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgenii Lepikhin wrote:
> Hello,
>
> We have several NAS servers with kernels 3.4.xx-3.13.xx. We've got a
> problem: after 1..4 months of work target servers stops responding to
> login requests.
>
I have seen a very similar problem on file servers, in my case an NFS workgroup 
server. I thought it was due to down level 3.8.13-fc17 kernel, not scheduled for 
upgrade for a few months yet, probably over Labor Day weekend.

However, existing connections on the machine also will respond to ENTER with a 
newline, but any connand requiring a new process hangs. It behaves as if the 
machine was out of processes, but I traced processes every few minutes and saw 
no buildup.

In addition, the machine hosts a virtual machine which continues to work just 
fine. Does any of this match additional issues you didn't mention or haven't 
checked?

[__ snip __]
>
> Any ideas?
>
May or may not be related, we have a console open on the machine and can verify 
the odd behavior.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
