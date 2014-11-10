Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaKJJlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:41:44 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45960 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaKJJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:41:43 -0500
Message-ID: <5460884C.1050401@linaro.org>
Date: Mon, 10 Nov 2014 09:41:32 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH RESEND 3.18-rc3 v2 0/2] trace: kdb: Bug fixes for ftdump
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>	<1415277716-19419-1-git-send-email-daniel.thompson@linaro.org> <20141106082728.5d4b7161@gandalf.local.home>
In-Reply-To: <20141106082728.5d4b7161@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 13:27, Steven Rostedt wrote:
> On Thu,  6 Nov 2014 12:41:54 +0000
> Daniel Thompson <daniel.thompson@linaro.org> wrote:
> 
>> This patchset makes it possible to use kdb's ftdump command without
>> panicing, crashing or livelocking. The ftdump command cannot be used
>> at all without these changes.
>>
>> IIRC this patches are still pending Jason's ack.
> 
> I haven't heard from Jason in a long time. Is he still active?

[sorry for the delay, I wanted to give Jason a chance to answer this]

Very occasionally.

I can't find anything on lkml in the last three months, and I have
unreviewed kdb patches that stretch back well beyond that.

That said he still helps people on kgdb-bugreport@ from time-to-time
(and as recently as last week). I've also had a little bit of private
contact although nothing very recent.

On that basis I'd say you shouldn't feel guilty if you have to accept a
change here without an ack.


Daniel.

