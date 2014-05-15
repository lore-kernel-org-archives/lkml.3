Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaEOKhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:37:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaEOKhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:37:31 -0400
Date: Thu, 15 May 2014 06:37:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Format of patches (was: [PATCH 1/2] speedstep-smi: enable interrupts
 when waiting)
In-Reply-To: <CAKohpo=h8cNbb2VbWzpDUPQDMK8QAs_sV=-SQyOaJWWFw4qKvA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1405150614100.19101@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405141012040.11670@file01.intranet.prod.int.rdu2.redhat.com> <CAKohpo=h8cNbb2VbWzpDUPQDMK8QAs_sV=-SQyOaJWWFw4qKvA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 May 2014, Viresh Kumar wrote:

> On 14 May 2014 19:54, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Hi Viresh
> >
> > Some times ago, I sent these two cpufreq patches to fix frequency
> > transition problem on speedstep-smi, but you didn't put them to the
> > upstream kernel. I am resending the patches. If you would like a different
> > solution to this problem, please explain it.
> 
> Probably these are just missed by Rafael. The patches are fine but the
> above paragraph you wrote would get into kernel logs and must have
> been placed below the three dash lines: "---"

I used "---" in the past, but some people complained that their script 
picks the text above "---" and ignores the text below "---" - thus, it 
does exactly the opposite of what it should do.

I don't know what kind of delimiter should I use. Suppose that I want to 
send something like this:




Hi, here I'm sending some cool stuff.

***

The message that goes to git.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/cpufreq/speedstep-lib.c |    3 +++
 drivers/cpufreq/speedstep-smi.c |   12 ++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-3.14-rc1/drivers/cpufreq/speedstep-smi.c
===================================================================
--- linux-3.14-rc1.orig/drivers/cpufreq/speedstep-smi.c 2014-02-03 
18:56:44.000000000 +0100
+++ linux-3.14-rc1/drivers/cpufreq/speedstep-smi.c      2014-02-03 
19:06:21.000000000 +0100
... the patch.




Now - I'm asking - what kind of barrier should I use between "Hi, here I'm 
sending some cool stuff" and "The message that goes to git"? I don't 
really know. The file Documentation/SubmittingPatches doesn't explain it, 
it says that the message for git should go at the top of the email. If I 
want the person who receives the patch to read "Hi, here I'm sending some 
cool stuff" first, I need to put it at the beginning of the email.

Maybe we should define a new barrier for this purpose, put it to 
Documentation/SubmittingPatches and update the scripts?

Mikulas
