Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3LBTZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:25:35 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35859 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3LBTZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:30 -0500
Message-ID: <529CDEA6.8000807@gmail.com>
Date: Mon, 02 Dec 2013 12:25:26 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
References: <20131202192315.GA17149@ghostprotocols.net>
In-Reply-To: <20131202192315.GA17149@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, 12:23 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 02, 2013 at 11:38:20PM +0900, Namhyung Kim escreveu:
>> Hi Arnaldo,
>>
>> 2013-12-02 (월), 09:33 -0300, Arnaldo Carvalho de Melo:
>>> Em Mon, Dec 02, 2013 at 03:53:19PM +0900, Namhyung Kim escreveu:
>>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>>
>>>> The --show-time-info option is for displaying elapsed sampling time
>>>
>>> Isn't that too long? Can't we use just --time/-t?
>>
>> Hmm.. interesting.  Your previous feedback was to use longer and clearer
>> option name. :)
>
>> https://lkml.org/lkml/2013/11/18/198
>
> Hey, longer and more descriptive names _when required_, in that case I
> thought that even being longer --show-task-events would be better, but
> here using --show-time-info the 'info' part looks superfluous, at least
> to me, hence my suggestion/question :-)
>

I thought -t/--time is going to be used to specify a time interval? 
Collect data for N-seconds, analyze some middle M-seconds.

David
