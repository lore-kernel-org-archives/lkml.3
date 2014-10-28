Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaJ1On1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:43:27 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:55434 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaJ1OnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <1414499805.2406.6.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	<1413914978.30379.14.camel@hadess.net>
	<20141022170433.GA10186@hungrycats.org>
	<1414420084.30379.53.camel@hadess.net>
	<20141027205936.GE17380@hungrycats.org>
	<1414499805.2406.6.camel@hadess.net>
Date: Tue, 28 Oct 2014 07:36:24 -0700
Message-ID: <CALAqxLUdkpwg=+Fcz+BKTAb1uzYbeSU0M6o5FcZGOD8X37Dfzw@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: John Stultz <john.stultz@linaro.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Zygo Blaxell <zblaxell@furryterror.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:36 AM, Bastien Nocera <hadess@hadess.net> wrote:
> Maybe the wake-up reason isn't good enough on its own, but how do I know
> which one the possible wake-up reasons was the last one to trigger?

So I feel like I'm still missing why its so critical to know what the
last-event was?  To me it seems a number of events have occurred, and
they should all be processed. Since they're all asynchronous, they
could come in any order, so it seems best handle them one by one
rather then have any requirement on which one happened last.

What does the exact timeline of the events provide for you?

thanks
-john
