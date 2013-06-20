Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3FTHdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:33:46 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:33320 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3FTHdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:33:45 -0400
Message-ID: <51C2B056.5010809@gmail.com>
Date: Thu, 20 Jun 2013 09:33:42 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: namhyung@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix bench numa compilation
References: <8761xd2k1c.fsf@sejong.aot.lge.com> <1371466499-28291-1-git-send-email-riccardo.magliocchetti@gmail.com> <20130619172310.GA2818@ghostprotocols.net>
In-Reply-To: <20130619172310.GA2818@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Il 19/06/2013 19:23, Arnaldo Carvalho de Melo ha scritto:
>> -					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
>> +				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016llx]\n",
>> +					process_nr, thread_nr, runtime_ns_max / bytes_done, (unsigned long long)val);
>
> Shouldn't this use PRIu64?

Will respin.

thanks,
riccardo
