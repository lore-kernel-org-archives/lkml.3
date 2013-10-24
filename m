Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3JXKXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:23:42 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:53118 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3JXKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:23:41 -0400
Message-ID: <5268F524.20505@gmail.com>
Date: Thu, 24 Oct 2013 11:23:32 +0100
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com>	<20130914161626.GD1718@localhost.localdomain> <CAFTL4hx=ycrepky0P3DYwoFBgknYumW6+tpW7PygqGD2ZNDFqg@mail.gmail.com>
In-Reply-To: <CAFTL4hx=ycrepky0P3DYwoFBgknYumW6+tpW7PygqGD2ZNDFqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/13 10:30 AM, Frederic Weisbecker wrote:
> Bah, checking that again, there don't seem to be a bug there. Actually
> the sample buffer is reset after we pick the last entry. So it looks
> all fine. I got confused as usual. Nevermind.

Ok. I had not come back to this thread since I decided on a different 
route for the event copying. I'll take it out of my to-do list.

David
