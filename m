Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaCOPqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:46:55 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56006 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbaCOPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:46:54 -0400
Message-ID: <532475EA.40306@gmail.com>
Date: Sat, 15 Mar 2014 09:46:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/10] perf, tools: Add jsmn `jasmine' JSON parser
References: <1394832698-322-1-git-send-email-andi@firstfloor.org> <1394832698-322-2-git-send-email-andi@firstfloor.org> <5323859B.70201@gmail.com> <20140315022707.GB22728@two.firstfloor.org>
In-Reply-To: <20140315022707.GB22728@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/14, 8:27 PM, Andi Kleen wrote:
> On Fri, Mar 14, 2014 at 04:41:31PM -0600, David Ahern wrote:
>> On 3/14/14, 3:31 PM, Andi Kleen wrote:
>>> @@ -374,6 +376,8 @@ LIB_OBJS += $(OUTPUT)util/stat.o
>>>   LIB_OBJS += $(OUTPUT)util/record.o
>>>   LIB_OBJS += $(OUTPUT)util/srcline.o
>>>   LIB_OBJS += $(OUTPUT)util/data.o
>>> +LIB_OBJS += $(OUTPUT)util/jsmn.o
>>> +LIB_OBJS += $(OUTPUT)util/json.o
>>>
>>>   LIB_OBJS += $(OUTPUT)ui/setup.o
>>>   LIB_OBJS += $(OUTPUT)ui/helpline.o
>>>
>>
>> CONFIG driven? Allow a user to omit this.
>
> Why? It has no external dependencies. AFAIK that's the only reason for configs.

We have also talked about config driven builds to allow pieces to be 
omitted -- e.g., to keep binary size down for embedded systems. This is 
clearly a standalone piece so why not add the config upfront now?

David

