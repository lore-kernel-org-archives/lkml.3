Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3C1SZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:25:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48854 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3C1SZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <51546359.8000002@gmail.com>
References: <alpine.LFD.2.03.1303272103380.8412@gmail.com>
	<5153B03E.2050201@gmail.com>
	<CAOULuOa1O5LxwDh6peSGBRR9PyeEtXuhyiaFVvKnFNiqrb4bfQ@mail.gmail.com>
	<51546359.8000002@gmail.com>
Date: Thu, 28 Mar 2013 14:25:55 -0400
Message-ID: <CAOULuOa70BDS8Sq2p9oC9MZGzjngJD5FB5Wdk4Sk1FXRJKrAnQ@mail.gmail.com>
Subject: Re: intel_pstate_timer_func divide by zero oops
From: Parag Warudkar <parag.lkml@gmail.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 11:35 AM, Dirk Brandewie
<dirk.brandewie@gmail.com> wrote:
>>> pid_param_set() is on the stack which means that something is changing
>>> the debugfs parameters or the stack is FUBAR.
>>>
>> I somehow doubt the stack is messed up as the call traces are always
>> identical.
>> (pid_param_set() seems to be in first trace as well.)
>>
>
> I agree that the two oops are likely the same but unless something is
> crawling
> through debugfs writing random values to the files there pid_param_set()
> should not be on any stack anywhere.

Ok.

>
> There was a similar bug reported by fedora:
> https://bugzilla.redhat.com/show_bug.cgi?id=920289
>
> This bug has not showed up again since rc3 can you try the current rc to see
> if
> you still see the problem?
>

I updated the Fedora BZ - the oops I got is from latest git as of
yesterday. So I think the bug is still there post -rc3.

Parag
