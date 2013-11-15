Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3KOHFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:05:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17467 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab3KOHE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:04:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,704,1378828800"; 
   d="scan'208";a="9042234"
Message-ID: <52867E0F.6020601@cn.fujitsu.com>
Date: Fri, 15 Nov 2013 15:03:27 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf kvm record: Change the default value of perf_guest
 to 0.
References: <1384465918-14085-1-git-send-email-yangds.fnst@cn.fujitsu.com> <528534E0.3030209@gmail.com>
In-Reply-To: <528534E0.3030209@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/15 15:03:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/15 15:03:07,
	Serialize complete at 2013/11/15 15:03:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David:

On 11/14/2013 03:38 PM, David Ahern wrote:
> On 11/14/13, 2:51 PM, Dongsheng Yang wrote:
>> Currently, we can not record the event counters of host to 
>> perf.data.host.
>> Example:
>>     perf kvm --host record -a sleep 1
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.625 MB perf.data.guest (~27290 
>> samples) ]
>
> perf kvm by definition wants --guest enabled. Host profiling is done 
> with just 'perf record'; no need for the kvm layer at all. If you 
> really want to go through perf-kvm to record host events disable guest 
> actions:
>
> $ perf kvm --host --no-guest record -a sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.029 MB perf.data.host (~1255 
> samples) ]
>
>
> David

Thanx for your reply ! It makes sense.


