Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaCSUHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:07:06 -0400
Received: from nm37-vm6.bullet.mail.bf1.yahoo.com ([72.30.238.206]:48474 "EHLO
	nm37-vm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065AbaCSUHE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:07:04 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 16:07:04 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 950435.54892.bm@omp1042.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=H7vvLOVAqsiIaJnVyavU/aS70S4wKYEFn3rNZabMwXkq4nv4v7n1makZAdJ8Vmrg7ZfFpnnb+nbgE0SmMqQdVC/kFKAbrnwFGqlsyPxOrLk9sSa5g0VP02NU2uYn0iL5AQwCtksMO9RBwzmqz5GZdoQKrrLlbkwdNnkaSBWoUZk=;
X-YMail-OSG: Nny0u90VM1l4HEfp0WGf.U1JuAznor7lhnaqoCmjvLP_iLj
 cjAlQgNhNgqhlAnJXy7.0HhR.fW1eNZedHXnQ8PwRsomNIlQzxmMKewlYbUq
 49HVqk5AQcTkEU3QeIkRSxOSZzhepn_sNdcz0FxkqFymy_Hk7FyAaCvGep2Z
 EOCJjZVbaj9HEdIjRtgac1kHc.KFtpY.up_qqmRKfU.2hmMFos9LadQv3C3P
 VGWx5BHyvMwenvgJ8KFa2v2yVtaToGsMsNR89sTAJiacrWnYyQQmmRnOD5IP
 3r_K58jGDDwW2hDLqsh3sfVEICWotF502OlwgWyWEQ9Ta6KGf7e5jaqGBCUX
 pd1QYR6lLty2XlpPLBrESweMzOK_KW1ghIbfy.PEQxT72Xhyq0j1gLrYaq4f
 8R9qidnplv7vOXM8ykSXCQs96xkd4dvvao8ex9hRWqrgKzA7TAlw.tJ2_lXw
 RCmyNMV0rpO7L4YlMJq81_eL6jMX4jQzjhi9XirXSW0VaTKIXclm5xOZYUb2
 tbfKyJcAickDHM9yM_e3huRVnpqWHzToldjkWBvCIPYk43wTB1_DV5LRuDSV
 3wOzJlw1dtitH6tUOusH3ZW2oUDiLl3yZoQGMHzK_egJ97FKqi323izPFHgF
 17kKfPH4uNdR2iJmAZGPcYww6CSg-
X-Rocket-MIMEInfo: 002.001,CgoKCk9uIFdlZG5lc2RheSwgTWFyY2ggMTksIDIwMTQgNDozNiBQTSwgSmFjayBDYXJyb3p6byA8amFja0BjcmVwaW5jLmNvbT4gd3JvdGU6Cgo.T24gV2VkLCBNYXIgMTksIDIwMTQgYXQgNzozNCBBTSwgTWFobW9vZCBOYWRlcmFuIDxudF9tYWhtb29kQHlhaG9vLmNvbT4gd3JvdGU6Cj4KPj4KPj4gWy4uLl0KPj4gRG8geW91IG1lYW4gaW5jbHVkZS9saW51eC9zY2hlZC5oID8KPj4gV2hlcmUgaXMgaGUgaW1wbGVtZW50YXRpb24gdGhlbj8KPgo.WW91ciBrZXJuZWwgc291cmNlIGlzIGluY29tcGxldGUuIFkBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.178.641
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>	<1395228430.4896.6.camel@marge.simpson.net>	<1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com> <CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>
Message-ID: <1395259275.22551.YahooMailNeo@web141602.mail.bf1.yahoo.com>
Date: Wed, 19 Mar 2014 13:01:15 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: Thread Scheduler
To: Jack Carrozzo <jack@crepinc.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Wednesday, March 19, 2014 4:36 PM, Jack Carrozzo <jack@crepinc.com> wrote:

>On Wed, Mar 19, 2014 at 7:34 AM, Mahmood Naderan <nt_mahmood@yahoo.com> wrote:
>
>>
>> [...]
>> Do you mean include/linux/sched.h ?
>> Where is he implementation then?
>
>Your kernel source is incomplete. You can fetch a vanilla kernel
>tarball from http://kernel.org.
>
>jackc@kdev0 ~ $ ls /usr/src/linux-2.6.10/kernel/|grep sched
>sched.c
>jackc@kdev0 ~ $ ls /usr/src/linux-3.13.5/kernel/sched/
>auto_group.c  completion.c  cpuacct.h  cputime.c  features.h   proc.c
>stats.c      wait.c
>auto_group.h  core.c        cpupri.c   debug.c    idle_task.c  rt.c     stats.h
>clock.c       cpuacct.c     cpupri.h   fair.c     Makefile     sched.h
>stop_task.c
>
>-J


OK I installed the full source and now can see the sched*.c files
One more question. Is it possible to dynamically change the scheduling policy, e.g from fair to clock? Basically, I am trying to find the direction on *how to invoke a new scheduling policy*?

