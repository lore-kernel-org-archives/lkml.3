Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3EJAeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:34:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38597 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab3EJAen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:34:43 -0400
Message-ID: <518C409F.3040906@gmail.com>
Date: Thu, 09 May 2013 18:34:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, fweisbec@gmail.com, peterz@infradead.org,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com> <1368073909-8825-11-git-send-email-dsahern@gmail.com> <20130509085137.GA8813@gmail.com> <518BAA92.2030101@gmail.com> <87k3n77k56.fsf@sejong.aot.lge.com>
In-Reply-To: <87k3n77k56.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 6:28 PM, Namhyung Kim wrote:
> Hi David,
>
> On Thu, 09 May 2013 07:54:26 -0600, David Ahern wrote:
>> On 5/9/13 2:51 AM, Ingo Molnar wrote:
>>> 2)
>>>
>>> Another suggestion: it would be nice to allow a "--repeat <n>" option as
>>> well, for a limited number of iterations - similar to what the 'top' tool
>>> allows:
>>>
>>>     top -b -d <delay> -n <iterations>
>>>
>>> --repeat 0 means infinite repeats, --repeat 1 means a single step.
>>
>> Missed that option in perf-top. Let me take a look at it.
>
> What Ingo said was plain "top" command, not the perf-top.

That would explain why I missed that option then. ;-)
Funny how your brain can fill in ...

David

