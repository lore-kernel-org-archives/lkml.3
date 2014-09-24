Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaIXPJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:09:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42233 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaIXPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:09:49 -0400
Message-ID: <5422DEBE.70503@linaro.org>
Date: Wed, 24 Sep 2014 16:09:50 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 3.17-rc4 v2 0/2] trace: kdb: Bug fixes for ftdump
References: <1410360247-13791-1-git-send-email-daniel.thompson@linaro.org>	<1411554781-16751-1-git-send-email-daniel.thompson@linaro.org> <20140924110719.165b5b5b@gandalf.local.home>
In-Reply-To: <20140924110719.165b5b5b@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/14 16:07, Steven Rostedt wrote:
> Is Jason Wessel still actively maintaining this?

He still maintaining kgdb and kdb although he is not in MAINTAINERS for
this particular file (perhaps he should be?).


> I'd like an acked-by from the KDB maintainer before pulling this.

Makes sense.


> 
> Thanks!
> 
> -- Steve
> 
> 
> On Wed, 24 Sep 2014 11:32:59 +0100
> Daniel Thompson <daniel.thompson@linaro.org> wrote:
> 
>> This patchset makes it possible to use kdb's ftdump command without
>> panicing, crashing or livelocking.
>>
>> Changes since v1:
>>
>> * Fixed use-after-free problems in v1 by adding logic to NULL out
>>   buffer_iter during free operations.
>>
>> * Introduced a second patch to fix a live lock when trying to display
>>   an empty trace buffer.
>>
>>
>> Daniel Thompson (2):
>>   trace: kdb: Fix kernel panic during ftdump
>>   trace: kdb: Fix kernel livelock with empty buffers
>>
>>  kernel/trace/trace_kdb.c | 21 +++++++++++++--------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> --
>> 1.9.3
> 

