Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722Ab3GZVih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:38:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42348 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666Ab3GZVic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:38:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rik van Riel <riel@redhat.com>, Jeremy Eder <jeder@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, youquan.song@intel.com,
        paulmck@linux.vnet.ibm.com, daniel.lezcano@linaro.org,
        len.brown@intel.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
Date: Fri, 26 Jul 2013 23:48:36 +0200
Message-ID: <1661917.srTpO55z5q@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51F2C014.90102@redhat.com>
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BF8C.7010308@linux.intel.com> <51F2C014.90102@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 02:29:40 PM Rik van Riel wrote:
> On 07/26/2013 02:27 PM, Arjan van de Ven wrote:
> > On 7/26/2013 11:13 AM, Rik van Riel wrote:
> >
> >>
> >> Could you try running the tests with just the repeat mode
> >> stuff from commit 69a37bea excluded, but leaving the common
> >> infrastructure and commit e11538?
> >>
> >
> > personally I think we should go the other way around.
> > revert the set entirely first, and now, and get our performance back
> > to what it should be
> >
> > and then see what we can add back without causing the regressions.
> > this may take longer, or be done in steps, and that's ok.
> >
> > the end point may well be the same... but we can then evaluate in the right
> > direction.
> 
> Works for me. I have no objection to reverting both patches,
> if the people planning to fix the code prefer that :)

OK, I'll queue up the reverts as fixes for 3.11-rc4.

Thanks,
Rafael

