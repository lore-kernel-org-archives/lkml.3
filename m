Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaLEPDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:03:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18657 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaLEPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:03:30 -0500
Message-ID: <5481C92E.6020805@oracle.com>
Date: Fri, 05 Dec 2014 10:03:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141127225637.GA24019@redhat.com>	<m5dart$co$1@ger.gmane.org>	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>	<547b8a45.6e608c0a.20f9.1002@mx.google.com>	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>	<547bbe36.48548c0a.105c.779c@mx.google.com>	<20141201191431.GA17385@linux.vnet.ibm.com>	<547ccf74.a5198c0a.25de.26d9@mx.google.com>	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>	<20141201230339.GA20487@ret.masoncoding.com>	<20141202193252.GB17595@redhat.com>	<547E4C14.6040509@oracle.com>	<54813C03.8040009@oracle.com> <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
In-Reply-To: <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 01:38 AM, Linus Torvalds wrote:
> On Thu, Dec 4, 2014 at 9:00 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > Just to add to this: I've enabled the simplest level of verbosity in the fault
>> > injection options, and RCU stalls are again easy to trigger:
> Where do you log to?
> 
> In particular, do you have some serial line logging enabled (perhaps
> even without anybody listening)? Or network logging?
> 
> We've definitely had cases where logging itself is so slow that it
> triggers watchdogs etc. Logging to a serial line can take for*ever* in
> modern terms..

Yes, it's going to a serial line, but it's only about 100 lines/second on
average. I wouldn't expect it to cause anything to hang!


Thanks,
Sasha
