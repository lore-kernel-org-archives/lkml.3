Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3KDXCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 18:02:10 -0500
Received: from zimbra3.corp.accelance.fr ([213.162.49.233]:58032 "EHLO
	zimbra3.corp.accelance.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3KDXCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 18:02:08 -0500
Message-ID: <5278276D.3040200@openwide.fr>
Date: Tue, 05 Nov 2013 00:02:05 +0100
From: Romain Naour <romain.naour@openwide.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Darren Hart <darren@dvhart.com>, Johannes Berg <johannes@sipsolutions.net>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] trace-cmd: use pkg-config instead of python-config
References: <1383241182-11162-1-git-send-email-romain.naour@openwide.fr>	<20131101171911.274da55e@gandalf.local.home>	<1383553971.14295.4.camel@jlt4.sipsolutions.net> <CAGChsmM39v=CLKD5=s5AmFGtpAbsM6KQQ-9K-=Kvis+6SM=ZMw@mail.gmail.com>
In-Reply-To: <CAGChsmM39v=CLKD5=s5AmFGtpAbsM6KQQ-9K-=Kvis+6SM=ZMw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 04/11/2013 23:20, Darren Hart a écrit :
> I'm hardly an expert here, but the appears sane to me. Perhaps a
> comment above the PYTHON_VERS describing what valid values are would
> be helpful. Otherwise, looks good to me.

Expected values are "python" and "python3" for PYTHON_VERS.

trace-cmd has been added in buildroot right after the 2013.08 release,
but several build failures has occurred in autobuilder like this one:
http://autobuild.buildroot.net/results/980/980875810528ac1dee34b8c268d9b3c40b2e35ec/build-end.log

Currently, we have two separate package for python2 and python3 in buildroot,
that's why I use PYTHON_VERS here.

See how trace-cmd.mk use PYTHON_VERS:
http://git.buildroot.net/buildroot/commit/?id=ff0367008c683362f422751644237218b1c45def

Best regards,
Romain Naour

> 
> On Mon, Nov 4, 2013 at 12:32 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Fri, 2013-11-01 at 17:19 -0400, Steven Rostedt wrote:
>>> Please Cc me on trace-cmd patches.
>>>
>>> Johannes and Darren,
>>>
>>> Since you handle the python bindings in trace-cmd, can you give me an
>>> ack or nack.
>>
>> Looks fine to me, in that it would work on my system :)
>>
>> johannes
>>
> 
> 
> 

