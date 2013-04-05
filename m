Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162149Ab3DEQx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:53:59 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:63497 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162136Ab3DEQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130405162746.GD20835@redhat.com>
References: <1365158085.2735.25.camel@menhir>
	<20130405162746.GD20835@redhat.com>
Date: Fri, 5 Apr 2013 09:53:54 -0700
X-Google-Sender-Auth: ry37uH8p6oIbAiRzYvwZZVlPnOg
Message-ID: <CA+55aFzPK1Sz_JO4iDvKSnPXdin8CBET7eisYFkMV8DctLfTZg@mail.gmail.com>
Subject: Re: GFS2: Pull request (fixes)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 9:27 AM, David Teigland <teigland@redhat.com> wrote:
> On Fri, Apr 05, 2013 at 11:34:45AM +0100, Steven Whitehouse wrote:
>> Please consider pulling the following changes,
>
> There's some mixup here that should be cleared up first.
>
>> David Teigland (2):
>>       GFS2: Fix unlock of fcntl locks during withdrawn state
>>
>> Steven Whitehouse (1):
>>       GFS2: Fix unlock of fcntl locks during withdrawn state

Looks like the summary line for one got leaked through an email
follow-up to the other. So now the summary of the second commit is
meaningless and doesn't actually describe it.

               Linus
