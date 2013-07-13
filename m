Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3GMMw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 08:52:56 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63417 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab3GMMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 08:52:54 -0400
Message-ID: <1373719972.1359.8.camel@x61.thuisdomein>
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
From: Paul Bolle <pebolle@tiscali.nl>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 13 Jul 2013 14:52:52 +0200
In-Reply-To: <1373710596.1352.26.camel@x61.thuisdomein>
References: <51C08370.4050906@gmx.de>
	 <CAKohpok1gThXL925Yz5UgC54vTVQgymBA1cLGER_g-dgZu0JLA@mail.gmail.com>
	 <51CF1E53.6060902@gmx.de> <8029836.CFiJCXmRQ0@vostro.rjw.lan>
	 <51D05DF4.50704@linux.vnet.ibm.com> <51D06556.7080204@gmx.de>
	 <51D07E7F.2030709@linux.vnet.ibm.com> <51DDC8FA.4020609@gmx.de>
	 <1373710596.1352.26.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2013 12:52:53.0259 (UTC) FILETIME=[E38385B0:01CE7FC7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 12:16 +0200, Paul Bolle wrote:
> I suspect that the stuck frequency is a regression introduced in v3.10.0.

The culprit apparently is commit a66b2e503f ("cpufreq: Preserve sysfs
files across suspend/resume"). Srivatsa submitted a patch to revert that
commit (see https://lkml.org/lkml/2013/7/11/661 ). That revert seems to
fix this issue too.


Paul Bolle

