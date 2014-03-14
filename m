Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaCNWlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:41:40 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42215 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaCNWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:41:39 -0400
Message-ID: <5323859B.70201@gmail.com>
Date: Fri, 14 Mar 2014 16:41:31 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, acme@infradead.org
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/10] perf, tools: Add jsmn `jasmine' JSON parser
References: <1394832698-322-1-git-send-email-andi@firstfloor.org> <1394832698-322-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1394832698-322-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/14, 3:31 PM, Andi Kleen wrote:
> @@ -374,6 +376,8 @@ LIB_OBJS += $(OUTPUT)util/stat.o
>   LIB_OBJS += $(OUTPUT)util/record.o
>   LIB_OBJS += $(OUTPUT)util/srcline.o
>   LIB_OBJS += $(OUTPUT)util/data.o
> +LIB_OBJS += $(OUTPUT)util/jsmn.o
> +LIB_OBJS += $(OUTPUT)util/json.o
>
>   LIB_OBJS += $(OUTPUT)ui/setup.o
>   LIB_OBJS += $(OUTPUT)ui/helpline.o
>

CONFIG driven? Allow a user to omit this.

David

