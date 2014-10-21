Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbaJUTsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:48:10 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36789 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbaJUTsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:48:09 -0400
MIME-Version: 1.0
In-Reply-To: <20141021194340.GT7996@ZenIV.linux.org.uk>
References: <1413881397.30379.7.camel@hadess.net> <5446B3CC.1080904@amacapital.net>
 <20141021194340.GT7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 21 Oct 2014 12:47:47 -0700
Message-ID: <CALCETrVRkO-KRTtnX69ku5DkVLmFLbMqK22B1xyEpWt-o-xK9Q@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Bastien Nocera <hadess@hadess.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 12:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Oct 21, 2014 at 12:28:12PM -0700, Andy Lutomirski wrote:
>
>> Why is kdbus needed?
>
> Presumably because freedesktop crowd has made an architectural mistake and
> pushed dbus as solution to all problems.  And ran into limitations of
> that, er, solution.  Then, instead of perhaps reconsidering the wisdom of
> their inspired decision, went for "let's push it kernelwards, it might
> somewhat reduce the overhead and problems will be easier to chalk up to
> something wrong being done by the kernel".

Well, yes, but the question I was actually trying to ask is: why does
a containerized app need any kernel help at all for communication with
the rest of the system (using dbus or anything else)?  Passing socket
fds into a container works just fine.

--Andy
