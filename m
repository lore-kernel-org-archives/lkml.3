Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3KFOyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:54:46 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56134 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab3KFOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:54:44 -0500
Message-ID: <527A582D.4000301@gmail.com>
Date: Wed, 06 Nov 2013 07:54:37 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: Fix version when building out of tree
References: <1383699213-23981-1-git-send-email-dsahern@gmail.com> <20131106053654.GA23746@gmail.com>
In-Reply-To: <20131106053654.GA23746@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/13, 10:36 PM, Ingo Molnar wrote:
> I think you could avoid the 'short' complication altogether by doing
> something like this:
>
>> +elif test -f ../../PERF-VERSION-FILE
>> +then
>> +	TAG=$(cut -d' ' -f3 ../../PERF-VERSION-FILE)
>
> That extracts 'TAG' as a true sha1 and makes GVF correct on out of tree
> builds as well.

Certainly. I was trying to make PERF-VERSION-FILE readable as a 
standalone file -- a better version descriptor than HEAD file.

David



