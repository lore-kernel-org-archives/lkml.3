Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818AbaCSLkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:40:40 -0400
Received: from nm12-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.140]:39793 "EHLO
	nm12-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933768AbaCSLki convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:40:38 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 07:40:38 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 687863.87202.bm@omp1015.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GLPLYsWXjvouHZE+38udHvaUKbDUwI3Or+88Oo95gStxjUZd0iTrgQ3y0u5JcpzQxRpGQJcdeAGOb3Rn7nleYuEtpD2ElSiMCxl0DucrAOOLl63SVmNiwyuGwZy2OdMYCJh/Wd5flR2rvns2iM++2KG60vnhVRt5ya1aMXBefDg=;
X-YMail-OSG: 6sM_VqcVM1mEdJ5s7KFSHsyvg1yWzg5BB1EojmBk.7c0HC_
 rxG50Mgw.pQCdLphs_WbIQjsAbS.36B3P46psQkxyJbI0x2oVuYKI9XVbBxl
 vpXrs1wtKmwlIci3HDqD0Ji6zGJ5GIA5rHF0jDjgKJAc2TlsZMw0mf4Ib46c
 5rSBuegw5H.ShVUULR5DBurCGAp6_leqA7.94Sr3MlOw0oZWmUECbATvb76k
 ItdflezV2SUAP_jGnaImZuCvAWAZuf3zszw03rEyo7mX1ugS6Yu4hMjW2s78
 khxlTe7vYHolFsehoGeMZJz8nyv3ZD.6BnliSoc.ioVpJ3GCbYmhm9sS120k
 SmSeBTBtLoDfxR3qYAzdFvoP5Xz9b3SVxuM5R10m0y620wmYlsCNmy1p4L4B
 niud2aN0kyWaFE3bcfLUtIoCZPS1WGi.sXncqTotcz_kh4SYEZLiX9JPl9.7
 L1rXxdPvu3X5RK1CmxlBfXxvPbexU4eRtq6pazPZ8ZOr8RXahDZ655lSXU0W
 GeQfMW2lOcuVDmNbiYJtNoc0T7TC2mUHVjTC9j8wmRV7QCz.vO.7kdTIJRuT
 RLD948.425_lzjBVawzgHO7N8SxlQ7HcfkAYnWER60f5KEaWrOpPrwVkxRll
 p0hzdVmHHbXCN_ArnOc9l9giG_RN61jbq
X-Rocket-MIMEInfo: 002.001,CgoKCj5PbiBXZWRuZXNkYXksIE1hcmNoIDE5LCAyMDE0IDM6NTcgUE0sIE1pa2UgR2FsYnJhaXRoIDx1bWd3YW5ha2lrYnV0aUBnbWFpbC5jb20.IHdyb3RlOgo.T24gV2VkLCAyMDE0LTAzLTE5IGF0IDAyOjU3IC0wNzAwLCBNYWhtb29kIE5hZGVyYW4gd3JvdGU6IAo.PiAKPj4gSGkKPj4gTWF5YmUgdGhpcyBpcyBhIG5vb2IgcXVlc3Rpb24uLi4KPj4gV2hlcmUgaW4gdGhlIGxpbnV4IGtlcm5lbCBzb3VyY2UgKDIuNiksIHRoZSAKPj4gCj4.IHRocmVhZCBzY2hlZHVsZXIgaGFzIGJlZW4gaW1wbGVtZW50ZWQBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.178.641
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com> <1395228430.4896.6.camel@marge.simpson.net>
Message-ID: <1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>
Date: Wed, 19 Mar 2014 04:34:03 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: Thread Scheduler
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1395228430.4896.6.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





>On Wednesday, March 19, 2014 3:57 PM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
>On Wed, 2014-03-19 at 02:57 -0700, Mahmood Naderan wrote: 
>> 
>> Hi
>> Maybe this is a noob question...
>> Where in the linux kernel source (2.6), the 
>> 
>> thread scheduler has been implemented? Searching 
>> 
>> the web shows that there should sched_fair.c but 
>> 
>> I can not find that in the source directory (the 
>> kernel source has been installed). 
>
>The scheduler recently moved to kernel/sched directory.  For older
>kernels, it's kernel/sched_*.
>
>-Mike


Please see this information

[root@tiger ~]# uname -a
Linux tiger 2.6.32-279.5.1.el6.x86_64 #1 SMP Tue Aug 14 16:11:42 CDT 2012 x86_64 x86_64 x86_64 GNU/Linux

[root@tiger ~]# ls /usr/src/kernels/2.6.32-279.5.1.el6.x86_64/kernel/
events  gcov  irq  Kconfig.freezer  Kconfig.hz  Kconfig.preempt  Makefile  power  time  trace

[root@tiger ~]# cd /usr/src/kernels/2.6.32-279.5.1.el6.x86_64/

[root@tiger 2.6.32-279.5.1.el6.x86_64]# find . -name sched*
./net/sched
./include/asm-generic/bitops/sched.h
./include/config/group/sched.h
./include/config/cgroup/sched.h
./include/config/schedstats.h
./include/config/fair/group/sched.h
./include/config/have/unstable/sched
./include/config/net/sched.h
./include/config/rt/group/sched.h
./include/config/sched
./include/trace/events/sched.h
./include/linux/sched.h
./include/linux/sunrpc/sched.h




Do you mean include/linux/sched.h ?
Where is he implementation then?

 
Regards,
Mahmood

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

