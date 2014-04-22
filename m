Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbaDVOD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:03:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55336 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaDVODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:03:17 -0400
Message-ID: <535676A1.3070706@kernel.dk>
Date: Tue, 22 Apr 2014 08:03:13 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
References: <cover.1395840483.git.agordeev@redhat.com> <20140422071057.GA13195@dhcp-26-169.brq.redhat.com>
In-Reply-To: <20140422071057.GA13195@dhcp-26-169.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-22 01:10, Alexander Gordeev wrote:
> On Wed, Mar 26, 2014 at 02:34:22PM +0100, Alexander Gordeev wrote:
>> But other systems (more dense?) showed increased cache-hit rate
>> up to 20%, i.e. this one:
>
> Hello Gentlemen,
>
> Any feedback on this?

Sorry for dropping the ball on this. Improvements wrt when to steal, how 
much, and from whom are sorely needed in percpu_ida. I'll do a bench 
with this on a system that currently falls apart with it.

-- 
Jens Axboe

