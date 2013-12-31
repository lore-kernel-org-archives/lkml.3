Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3LaB7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:59:50 -0500
Received: from nm37-vm1.bullet.mail.bf1.yahoo.com ([72.30.238.201]:34360 "HELO
	nm37-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752516Ab3LaB7t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:59:49 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Dec 2013 20:59:49 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 969309.76375.bm@omp1056.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KB6yaEMhGKmOSXMPkmga+HfAeqy4W8QJeigZy7uaRwiBWfk5afegwzB3VeDkyvd5qCQYSNEILgRUA0M6puhsQ76JDlPRv9my4nYQib3ZCEdHzsDBCXnCGfM27qP5OBft6Za0iac8AbUzQiMlTCPPcWh2n85yiGuCA6cM13YtorI=;
X-YMail-OSG: tHVycpQVM1k8b8TKBSYVSdDPl5zCrdKKVKLZNix6tKYJyr6
 X2lCrP1AUvCKMMl9T7VNtq9CsjCJ.YH2grQF2cJBSYX.W1d2uQMqi23Os7U4
 zAiwKtZABX5WZ4mvwyWx7YUDnWhPzTGzaJaYdsR7gfYN6duIt0W8TCZUdfel
 2l_GWUpaxf2sel.60T2IsItWzYxLduwFqxnGEzb0LPuLL3NCQ2A0j72B0VsK
 Z1Krb31pd9n3vYDC1VFzFktnJ14Ut_f121CYedtDlp9lSPhVg4DMlPOWNE2Q
 FIFbAEuFG__17wgMrtRdGBy5DrUA9Us9aij0it7ZnlRB9Dg1dIU0lLFeHEqe
 Id6Y2XS0m6tGa4kWWz1qwwTc2EByX.IUqtAOLxYEplWD.xn0dv66cJU8eSEG
 nj3Qwfl9v.BkSMCdyTVt9Pw_55A9G6FyWOwJk81FfZxgeORZft3AuFp6UQmw
 FXIQLhHFeaKRB1xfjI6JFzwj7n7_nmCZXOkGMV9OhQcUOx8guss1H94qzIV1
 0f561OSyzJpvXqfxYrLmivpvtIZB2TQaJUQMxUN3QeM82ZBOd06vQ3rCqRXA
 hUoJVQ88EfiLw478z9JywKPaDSc944XFKf8RMr_WDvZmwsh.owr302yTKnlM
 41rsYWSo9V0lUH9PCzfVW2zBcsFl3XUGdaOz2eKvxJzg-
X-Rocket-MIMEInfo: 002.001,CgoKCgo.X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBGcm9tOiBTdGVmYW4gQmVsbGVyIDxzdGVmYW5iZWxsZXJAZ29vZ2xlbWFpbC5jb20.Cj5UbzogUElOVFUgS1VNQVIgPHBpbnR1X2FnYXJ3YWxAeWFob28uY29tPjsgImxpbnV4LW1tQGt2YWNrLm9yZyIgPGxpbnV4LW1tQGt2YWNrLm9yZz47ICJsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47ICJtZ29ybWFuQHN1c2UuZGUiIDxtZ29ybWFuQHN1c2UuZGU.IAo.U2VudDogTW9uZGEBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.172.614
References: <1388341026.52582.YahooMailNeo@web160105.mail.bf1.yahoo.com> <52C0854D.2090802@googlemail.com>
Message-ID: <1388454855.7071.YahooMailNeo@web160101.mail.bf1.yahoo.com>
Date: Mon, 30 Dec 2013 17:54:15 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: Help about calculating total memory consumption during booting
To: Stefan Beller <stefanbeller@googlemail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
In-Reply-To: <52C0854D.2090802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org






>________________________________
> From: Stefan Beller <stefanbeller@googlemail.com>
>To: PINTU KUMAR <pintu_agarwal@yahoo.com>; "linux-mm@kvack.org" <linux-mm@kvack.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "mgorman@suse.de" <mgorman@suse.de> 
>Sent: Monday, 30 December 2013 1:55 AM
>Subject: Re: Help about calculating total memory consumption during booting
> 
>
>On 29.12.2013 19:17, PINTU KUMAR wrote:
>> Hi,
>> 
>> I need help in roughly calculating the total memory consumption in an embedded Linux system just after booting is finished.
>> I know, I can see the memory stats using "free" and "/proc/meminfo"
>> 
>> But, I need the breakup of "Used" memory during bootup, for both kernel space and user application.
>> 
>> Example, on my ARM machine with 128MB RAM, the free memory reported is roughly:
>> Total: 90MB
>> Used: 88MB
>> Free: 2MB
>> Buffer+Cached: (5+19)MB
>> 
>> Now, my question is, how to find the breakup of this "Used" memory of "88MB".
>> This should include both kernel space allocation and user application allocation(including daemons).
>> 
>
>http://www.linuxatemyram.com/ dont panic ;)
>
>How about htop, top or
>"valgrind --tool massif"
>
>



Thanks for the reply, I know about top, but top does not help much in arriving at the total memory consumption.


I need the physical memory usage breakup of each process during bootup, with a segregate of user and kernel allocation.

1) If I add up all "Pss" field in "proc/<PID>/smaps, do I get the total Used memory?
2) Is the Pss value includes the kernel side allocation as well?
3) What fields I should choose from /proc/meminfo" to correctly arrive at the "Used" memory in the system?
4) What about the memory allocation for kernel threads during booting? Why does its Pss/Rss value shows 0 always

I already tried adding up all "PSS" values in every PIDs, but still it does not match any where near to the total used memory in the system.

Please help.
