Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaEOQJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:09:22 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:41282 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaEOQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:09:21 -0400
MIME-Version: 1.0
X-Originating-IP: [80.246.32.33]
In-Reply-To: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
Date: Thu, 15 May 2014 18:09:20 +0200
Message-ID: <CAPh34me=yxjs2LR+_eiTyrQKFzDDtr95i_3+HDwHPPxYfZDLqw@mail.gmail.com>
Subject: Re: perf: Add support for full Intel event lists v3
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2014 00:51, Andi Kleen <andi@firstfloor.org> wrote:

> I implemented an automatic downloader to get the event file for the
> current CPU.  The events are stored in ~/.events.
> Then perf adds a parser that converts the JSON format into perf event
> aliases, which then can be used directly as any other perf event.

Should the name of the file not more specific? I mean .events can mean
everything? Every program may have a demand for this generic name. Why
not ~/.perf-events? Even more standard [1]:
$XDG_CACHE_HOME/perf/events (i.e. ~/.cache/perf/events)

[1] http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
