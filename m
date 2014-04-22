Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaDVTTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:19:20 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51642 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaDVTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:19:17 -0400
Message-ID: <5356C0B1.8050709@gmail.com>
Date: Tue, 22 Apr 2014 13:19:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        William Cohen <wcohen@redhat.com>
Subject: Re: mapping instructions to dynamic languages like java, python,
 ruby
References: <20140422180305.GK8488@redhat.com> <CABPqkBTJ4==4FF2KLVGzvpGSX_RhHVZWUH5h9Vvi+XG_xJSUEQ@mail.gmail.com>
In-Reply-To: <CABPqkBTJ4==4FF2KLVGzvpGSX_RhHVZWUH5h9Vvi+XG_xJSUEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/14, 1:05 PM, Stephane Eranian wrote:
> I intend to contribute that code for perf once it is finalized.
> Note that it uses a module developed by Sonny Rao to
> export the perf timestamp time source via a posix-clock.
> This clock discussion has been going on for a while and
> never reached a conclusion. So I decided to go with the
> simple posix-clock module for the time being.

I don't recall Sonny creating one. If you are referring to the one I 
mention here:
  https://github.com/dsahern/linux/blob/perf-full-monty/README.ahern

It's from Pawel Moll.

David
