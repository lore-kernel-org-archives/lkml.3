Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaGLPpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 11:45:13 -0400
Received: from cmta2.telus.net ([209.171.16.75]:56522 "EHLO cmta2.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaGLPpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 11:45:11 -0400
X-Authority-Analysis: v=2.0 cv=A6SyydqG c=1 sm=2
 a=zJWegnE7BH9C0Gl4FFgQyA==:17 a=n-4vetG2bxcA:10 a=LGgl8L9ij00A:10
 a=kj9zAlcOel0A:10 a=aatUQebYAAAA:8 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19
 a=Fp5vh2oxAAAA:20 a=7IC5b9jbIkkJtVQgXD8A:9 a=CjuIK1q_8ugA:10
 a=zJWegnE7BH9C0Gl4FFgQyA==:117
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Stratos Karafotis'" <stratosk@semaphore.gr>, <rjw@rjwysocki.net>,
        <viresh.kumar@linaro.org>
Cc: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
In-Reply-To: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
Subject: RE: [PATCH 0/2] cpufreq: ondemand: Eliminate the deadband effect
Date: Sat, 12 Jul 2014 08:45:09 -0700
Message-ID: <000001cf9de8$43925230$cab6f690$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+UhLPKN2qCqxKCTDON1nL7fb/pyQJYpFJA
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014.07.30 10:00 Stratos Karafotis wrote:

> This patchset changes slightly the calculation of target frequency to
> eliminate the deadband effect (explained in patch 2 changelog) that it
> seems to slow down the CPU in low and medium loads.
>
> Patch 1 introduces a new relation (RELATION_C) for the next frequency
> selection, which chooses the closest frequency to target.
>
> Patch 2 is the actual change to ondemand governor.

> You may find graphs with the 'deadband' effect and benchmark results:
> https://docs.google.com/spreadsheets/d/16kDBh5lyc6YvBnoS1hUa1t2O38z0xrWvaEj5XtJ8auw/edit#gid=2072493052

I did the same benchmark tests before (without) and after (with) this patch set on my i7-2600K system.
I added the results, which are similar to Stratos', under a new "benchmark" tab on the spreadsheet.

... Doug


