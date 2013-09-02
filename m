Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3IBMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:25:56 -0400
Received: from nm10-vm2.bullet.mail.gq1.yahoo.com ([98.136.218.93]:30749 "EHLO
	nm10-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab3IBMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:25:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 200078.55603.bm@omp1031.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=fn6ewvDkbvxFJmqQLrt79OEkzEHg6wLBlvfRTRu5Y33T1A425TcvL2dDHwuNY9fAQvAH9Agthg6qp8nrUNRZeTRad+m2WxxToqw95YgQ30BAD69T+9S1fOBhX8YSVue268X+w3wGFoLcjV/hvCDVMTb1FKM5yA++Pi2NeJ+rATY=;
X-YMail-OSG: nepvO58VM1mQAkY2kHTzXRGCiKvPkinPKa.iYdYQjfFRPfN
 satHS8mEs9BbJniiPdYw1uUZpDsIwWe76El3kO9ACD_tcJ73VQjnCeh5HPzB
 Yu4hlCHYCa9cWcHAO1hK8mPXSYmIaLgZwxA6AagfKyp5K.jHvC9eyFTzhp7a
 JuKnZik9_IUTGWO63yEilL4YFzrnz5YDdVIvfT9INZtPPvVnpa0DmYXQ9Rq8
 j6WGOke1pxJS5cqY_Jjt_WIwP9tT39NMmAoqRG7eXZ2VgDQz5a34Y8tYSzF9
 qQRLfImnU7TJ4_07b45R98gcYC3RW1_4lHJVLB_nHz_YhECHM0VLCUh75pKE
 5oYprXAx2OPlLp58u83XCPvamnUlDM383AKEgNmo5G4iK55zXOwU2G9P75fT
 pPf9B7Ue_66F.fXnTJdbho7mWc2FNocs2bYTxzr_J3eA3xJvkLFsjIghhl7F
 3xqFzWuukQFRbZAAuOycYMEqxJHXHIQqxHlfU6i3dwDJvyXwnyw0Ol1H7
X-Rocket-MIMEInfo: 002.001,aGksCgppIGFtIHRyaW5nIGRlYnVnIGEgYXBwbGljYXRpb24gb24gYW4gYXJtIGJhc2VkIGRldmljZSB1c2luZyBnZGJzZXJ2ZXIsIGluIGNvZGUgaSBhbSB0cnlpbmcgdG8gYWRkIGBzZXRfZGVidWdfdHJhcHMnIGFuZCBgYnJlYWtwb2ludCcgZnVuY3Rpb25zIGJ1dCBpdHMgZ2l2aW5nIG1lIGNvbXBpbGF0aW9uIGVycm9yIHNvbWV0aGluZyBsaWtlCgp1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBzZXRfZGVidWdfdHJhcHMnCm11bHRpc29jLmM6NTk0OiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBicmVha3BvaW4BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.156.576
Message-ID: <1378124754.88677.YahooMailNeo@web163904.mail.gq1.yahoo.com>
Date: Mon, 2 Sep 2013 05:25:54 -0700 (PDT)
From: Suki Buryani <sukiburyani@yahoo.com>
Reply-To: Suki Buryani <sukiburyani@yahoo.com>
Subject: can not debug using gdbserver
To: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i am tring debug a application on an arm based device using gdbserver, in code i am trying to add `set_debug_traps' and `breakpoint' functions but its giving me compilation error something like

undefined reference to `set_debug_traps'
multisoc.c:594: undefined reference to `breakpoint'

i am also tring to debug my code with using these function, after successfull burn and listen from remote connection, i am trying to add break point from main() but it tries to make breakpoint in shared liberaies and do not stop at that point.

anybody have idea what i am missing, how i can successfull use up gdbserver

thanks

