Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaCWLHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 07:07:47 -0400
Received: from n6-vm6.bullet.mail.bf1.yahoo.com ([72.30.234.93]:46733 "EHLO
	n6-vm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbaCWLHp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 07:07:45 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Mar 2014 07:07:45 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 484475.30743.bm@omp1039.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mzHrXU0Jj/DBSwN7yJEVrpF6rJ4Wi0WfykHHJ8uD0DtQDkc3wwSeVRF6LVQTZ0a7Q3S1elCmB98XAXRWbIOuy2yNUjARbE2X86L/WB0RcCR+FN2kMKrOtqHv1IQKlFM2ShkRw7ER0bSKDuTCkxpCqpZZyq+HECJzZaNO8k4jIU4=;
X-YMail-OSG: 2rfDrfUVM1kgl4LANHa1jGD5DURTs_7Sw9n18Wu9uB0Py_N
 kPdpm2UV3UkrJCN9gI8D41YEqtIgpBdHFrBAL3TF_Bn1ATBjQikf3IRS1xmx
 vK7n1fXQIaAza2VDEjfLGSyMn9JvN4AWoHkvFT6F1SyNjfJ82BKlpKLqWUXZ
 fQp9k5IJeZn1RdyhaPOAzfHmZiVy78hD8w7wznFSEeIpSYNrJ2FpY_Pz6uGM
 U3efFyGqt7eK0VD3LBRl2YkCXq6VMIKNb20QDeoFPybQp4Tc37xYRWV4fncW
 0TcKaruH0caVMhlfVpQsWiLlfJlPXEYAwD27O6_Ty74eYL05QEMG1JV6T_zI
 bilHsZT4obiUswWKJl6ihfKLZqE5yTjNl5vgNq4oIv_Hlja0N70GzcmAa5cN
 fWoxRwrxbWUBQFR3KUANgQB5kWtPpdUiIYOaGXhoJwG6YGuIU4HYcgfgnxnE
 jjQAPyulXkgQLznZ3j_azozo.Ikua1eQIRmqVMhKavSmjLMVwzf5iL1hp7o3
 ku.j37zsMltsG_DU.x69HTKUhR_Uzsldt7hMS4mMPt91O0G8pkSa1XODqX8o
 CqqOYiRVu_XMh
X-Rocket-MIMEInfo: 002.001,CgoKCgoKPk9uIFRodXJzZGF5LCBNYXJjaCAyMCwgMjAxNCA2OjUzIEFNLCBNaWtlIEdhbGJyYWl0aCA8dW1nd2FuYWtpa2J1dGlAZ21haWwuY29tPiB3cm90ZToKPgo.bWFyZ2U6fiAjIG1hbiAtayBzZXRzY2hlZHVsZXIgZ2V0c2NoZWR1bGVyCj5zY2hlZF9zZXRzY2hlZHVsZXIgKDIpIC0gc2V0IGFuZCBnZXQgc2NoZWR1bGluZyBwb2xpY3kvcGFyYW1ldGVycwo.c2NoZWRfc2V0c2NoZWR1bGVyICgzcCkgLSBzZXQgc2NoZWR1bGluZyBwb2xpY3kgYW5kIHBhcmFtZXRlcnMgKFJFQUxUSU1FKQo.c2NoZWRfZ2UBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.181.645
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>	 <1395228430.4896.6.camel@marge.simpson.net>	 <1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>	 <CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>	 <1395259275.22551.YahooMailNeo@web141602.mail.bf1.yahoo.com> <1395282203.11039.24.camel@marge.simpson.net> 
Message-ID: <1395572478.74811.YahooMailNeo@web141601.mail.bf1.yahoo.com>
Date: Sun, 23 Mar 2014 04:01:18 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: Thread Scheduler
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Jack Carrozzo <jack@crepinc.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1395282203.11039.24.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org







>On Thursday, March 20, 2014 6:53 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
>
>marge:~ # man -k setscheduler getscheduler
>sched_setscheduler (2) - set and get scheduling policy/parameters
>sched_setscheduler (3p) - set scheduling policy and parameters (REALTIME)
>sched_getscheduler (2) - set and get scheduling policy/parameters
>sched_getscheduler (3p) - get scheduling policy (REALTIME)





OK I read them and it seems that in order to change the scheduler, I have to write a C code and call the sched_set* functions. Please correct that if I am wrong.

So in order to use my custom scheduler, I have to do the following steps.

1- Write my  code using the APIs and save that in kernel/sched_custom.c
2- Invoke sched_custom.c in kernel/sched.c
3- Recompile the kernel source
4- Reboot using the new kernel
5- write a C code and call sched_setschedule() to use my scheduler.

Is that all? Your reply is appreciated.


Regards,
Mahmood 
