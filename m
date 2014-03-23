Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaCWO1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 10:27:30 -0400
Received: from nm2-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.158]:29757 "EHLO
	nm2-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbaCWO13 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 10:27:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 810636.87454.bm@omp1025.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2HhDJNVUx02883mWUnrNzfYYJJ2LIaDrmvtKQdS88iL4cAfWUI41siJ6vhtoT60dpqNq39h7Hig3HcwSKgC4FSyZmMIcDZ968kNzMlyOdWW8V5zJhEl4Q42e/+oTLcg6gIyNJJ9fqFP8Oucq7dpe20fneV/oDOkU7yd8kgVR95s=;
X-YMail-OSG: ck52ccEVM1kjtjnuUwsz2zFREdW_PpiEp9V9PrEzy7moB9r
 FKXRgvZKeQN51yoIZuY6qegqgzr4bW5HfOtR1elzh8sAjTbiUX8uh_RJP9z7
 xpJ9E_y_SQlVVTYZ4_87CgI02xiA.3lsFidOh0IEjQ2MZCL3kHrAm1ZbUoPI
 dw4qEMgRLCkQbdpff7mMu2bfRkPYpKtX9QiHdC8gQMAfx8cVoSE_QW.zkeYs
 BPgGOxrIZ1BN9z0XPq1ytjk8rm3L7JQMMapH1OyDs19w5kueJztz88HgKAuN
 7gWpw5wvESTHL362vgbL3eyJHdgP9qOh7rwFsgjJTwBYUVrPEFPD3Vxe1eP5
 s3Jrp5VFPDnqvx90l80v6ExCmbDgSbVdeabp.6CODaBcHiln1QI.jYdU8wr8
 7DCZRdc8c6JzOfu4NKY2s.HSx0PcZB5ZdBcVgVgfCWXSmvMVYhVD4GQs9S50
 fDlkNJ._k_SjCSHJlww.200v.1bCrBiruggf0nmvJvVQ3FPJYOy0eGDkXxY8
 oOR0UxjgY.a65eG5xLdLOlnRDZA4JGEK9DgqNilGu_SAOqMBEVcHGrhZIFl6
 dWwPllO542d8.
X-Rocket-MIMEInfo: 002.001,CgoKCk9uIFN1bmRheSwgTWFyY2ggMjMsIDIwMTQgNjozNSBQTSwgTWFyayBLbmVjaHQgPG1hcmtrbmVjaHRAZ21haWwuY29tPiB3cm90ZToKPkluIHRlcm1zIG9mIGNoYW5naW5nIHRoZSBzY2hlZHVsZXIgSSB0aGluayB0aGF0IHlvdSBwb3NzaWJseSBtaXNzZWQKPnJlYWRpbmcgRG9jdW1lbnRhdGlvbi9ibG9jay9zd2l0Y2hpbmctc2NoZWQudHh0IGluIHRoZSBrZXJuZWwncwo.ZG9jdW1lbnRhdGlvbiBkaXJlY3RvcnkuCj4KPkhUSCwKPk1hcmsKClRoYXQgaXMgSU8gc2NoZWR1bGVyLiBDYW4gd2UgdXNlIHQBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.181.645
References: <1395223046.28757.YahooMailNeo@web141601.mail.bf1.yahoo.com>	<1395228430.4896.6.camel@marge.simpson.net>	<1395228843.40159.YahooMailNeo@web141603.mail.bf1.yahoo.com>	<CAJ__M-3RTLqU5MBVDGkXXw7cGriRCtfcb3pnMwGpXuJPMxeYHw@mail.gmail.com>	<1395259275.22551.YahooMailNeo@web141602.mail.bf1.yahoo.com>	<1395282203.11039.24.camel@marge.simpson.net>	<1395572478.74811.YahooMailNeo@web141601.mail.bf1.yahoo.com> <CAK2H+edMBcJhqe8=hQvCRYAm6GsqnoqwqU5By_FD6qMyoXvCjQ@mail.gmail.com>
Message-ID: <1395584848.57698.YahooMailNeo@web141603.mail.bf1.yahoo.com>
Date: Sun, 23 Mar 2014 07:27:28 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: Thread Scheduler
To: Mark Knecht <markknecht@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Jack Carrozzo <jack@crepinc.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAK2H+edMBcJhqe8=hQvCRYAm6GsqnoqwqU5By_FD6qMyoXvCjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Sunday, March 23, 2014 6:35 PM, Mark Knecht <markknecht@gmail.com> wrote:
>In terms of changing the scheduler I think that you possibly missed
>reading Documentation/block/switching-sched.txt in the kernel's
>documentation directory.
>
>HTH,
>Mark

That is IO scheduler. Can we use the same for threads/processes? 
echo deadline > /proc/10100

Or something like that?


 
Regards,
Mahmood

