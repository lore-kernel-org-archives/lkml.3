Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3LBBva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:51:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab3LBBv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:51:29 -0500
X-IronPort-AV: E=Sophos;i="4.93,807,1378828800"; 
   d="scan'208";a="9167281"
Message-ID: <529C9DFD.6040707@cn.fujitsu.com>
Date: Mon, 02 Dec 2013 09:49:33 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf Makefile: Correct the message in feature-libnuma
 checking.
References: <1385759152-19752-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131129181417.GA9876@ghostprotocols.net> <529C9521.6020300@cn.fujitsu.com> <529BE386.9060601@hurleysoftware.com>
In-Reply-To: <529BE386.9060601@hurleysoftware.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/02 09:51:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/02 09:51:23,
	Serialize complete at 2013/12/02 09:51:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2013 08:33 PM, Peter Hurley wrote:
> On 12/02/2013 09:11 AM, Dongsheng Yang wrote:
>> ccing linux-kernel@vger.kernel.org
>>
>> On 11/29/2013 01:14 PM, Arnaldo Carvalho de Melo wrote:
>>> Em Fri, Nov 29, 2013 at 04:05:52PM -0500, Dongsheng Yang escreveu:
>>>> The package required for numa is named numactl-devel in Fedora and 
>>>> RHEL and
>>>> libnuma-devel in OpenSuSE. This patch correct the package name in 
>>>> warning
>>>> message.
>
> and libnuma-dev in Ubuntu.
>

Right, I will send v2 with 'numactl-devel/libnuma-dev/libnuma-devel'.

Thanx Peter.
>>> Applying, but please always CC linux-kernel@vger.kernel.org, so that
>>> others can review it as well.
>>
>> Okey!!
>>
>> Thanx Arnaldo.
>>>
>>> - Arnaldo
>>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>>> ---
>>>>   tools/perf/config/Makefile | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>>>> index 80ea6d8..2e615d8 100644
>>>> --- a/tools/perf/config/Makefile
>>>> +++ b/tools/perf/config/Makefile
>>>> @@ -537,7 +537,7 @@ endif
>>>>   ifndef NO_LIBNUMA
>>>>     ifeq ($(feature-libnuma), 0)
>>>> -    msg := $(warning No numa.h found, disables 'perf bench numa 
>>>> mem' benchmark, please install numa-libs-devel or libnuma-dev);
>>>> +    msg := $(warning No numa.h found, disables 'perf bench numa 
>>>> mem' benchmark, please install numactl-devel or libnuma-devel);
>>>>       NO_LIBNUMA := 1
>>>>     else
>>>>       CFLAGS += -DHAVE_LIBNUMA_SUPPORT
>>>> -- 
>>>> 1.8.2.1
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

