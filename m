Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3KOEBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:01:10 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57281 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3KOEBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:01:04 -0500
MIME-Version: 1.0
In-Reply-To: <1383804763.7940.59.camel@joe-AO722>
References: <51F73A17.2090208@akamai.com>
	<1382974150-7392-1-git-send-email-changbin.du@gmail.com>
	<20131031155253.79a21d6a126be11a64153d8b@linux-foundation.org>
	<1383262255.2769.11.camel@joe-AO722>
	<CABgQ-Tgzbhy=vrofs2jYpwySzOw5mU7GZPDax2ueEYSA8iHh3w@mail.gmail.com>
	<1383804763.7940.59.camel@joe-AO722>
Date: Fri, 15 Nov 2013 12:01:02 +0800
Message-ID: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
Subject: Re: [PATCH v2] dynamic_debug: add wildcard support to filter files/functions/modules
From: Changbin Du <changbin.du@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@akamai.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/7 Joe Perches <joe@perches.com>:
> On Thu, 2013-11-07 at 11:11 +0800, Changbin Du wrote:
>> 2013/11/1 Joe Perches <joe@perches.com>:
>> match_<foo> functions in lib/parser.c just do simple match, they
>> doesn't support wildcards.
>> So it's not useful for us.
>
> It's not meant to be useful so much as be a possible
> generic location for your match_regex function.
>
I misunderstood you. This is a appropriate file to place the matching function.
I have moved it to this file.

I checked the regex_match_foo  functions in  trace_events_filter.c. Per my
reading, I think it's a little tedious, and only support '*' character. They are
glued with tracing framework. So i gave up to re-used them.

I will send new version patch set to you later.

Thanks!
Du, Changbin
