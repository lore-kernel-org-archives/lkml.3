Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3KDWUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:20:08 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:48053 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3KDWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:20:06 -0500
MIME-Version: 1.0
In-Reply-To: <1383553971.14295.4.camel@jlt4.sipsolutions.net>
References: <1383241182-11162-1-git-send-email-romain.naour@openwide.fr>
	<20131101171911.274da55e@gandalf.local.home>
	<1383553971.14295.4.camel@jlt4.sipsolutions.net>
Date: Mon, 4 Nov 2013 14:20:05 -0800
X-Google-Sender-Auth: EOBsaqEQLGo0mVGnOfKh7YFA3zw
Message-ID: <CAGChsmM39v=CLKD5=s5AmFGtpAbsM6KQQ-9K-=Kvis+6SM=ZMw@mail.gmail.com>
Subject: Re: [PATCH 1/1] trace-cmd: use pkg-config instead of python-config
From: Darren Hart <darren@dvhart.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Romain Naour <romain.naour@openwide.fr>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm hardly an expert here, but the appears sane to me. Perhaps a
comment above the PYTHON_VERS describing what valid values are would
be helpful. Otherwise, looks good to me.

On Mon, Nov 4, 2013 at 12:32 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-11-01 at 17:19 -0400, Steven Rostedt wrote:
>> Please Cc me on trace-cmd patches.
>>
>> Johannes and Darren,
>>
>> Since you handle the python bindings in trace-cmd, can you give me an
>> ack or nack.
>
> Looks fine to me, in that it would work on my system :)
>
> johannes
>



-- 
Darren Hart
