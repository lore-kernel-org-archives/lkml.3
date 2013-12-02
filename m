Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3LBBeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:34:06 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:56592 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752466Ab3LBBeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:34:03 -0500
Message-ID: <529BE386.9060601@hurleysoftware.com>
Date: Sun, 01 Dec 2013 20:33:58 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf Makefile: Correct the message in feature-libnuma
 checking.
References: <1385759152-19752-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131129181417.GA9876@ghostprotocols.net> <529C9521.6020300@cn.fujitsu.com>
In-Reply-To: <529C9521.6020300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 09:11 AM, Dongsheng Yang wrote:
> ccing linux-kernel@vger.kernel.org
>
> On 11/29/2013 01:14 PM, Arnaldo Carvalho de Melo wrote:
>> Em Fri, Nov 29, 2013 at 04:05:52PM -0500, Dongsheng Yang escreveu:
>>> The package required for numa is named numactl-devel in Fedora and RHEL and
>>> libnuma-devel in OpenSuSE. This patch correct the package name in warning
>>> message.

and libnuma-dev in Ubuntu.

>> Applying, but please always CC linux-kernel@vger.kernel.org, so that
>> others can review it as well.
>
> Okey!!
>
> Thanx Arnaldo.
>>
>> - Arnaldo
>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>> ---
>>>   tools/perf/config/Makefile | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>>> index 80ea6d8..2e615d8 100644
>>> --- a/tools/perf/config/Makefile
>>> +++ b/tools/perf/config/Makefile
>>> @@ -537,7 +537,7 @@ endif
>>>   ifndef NO_LIBNUMA
>>>     ifeq ($(feature-libnuma), 0)
>>> -    msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
>>> +    msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel or libnuma-devel);
>>>       NO_LIBNUMA := 1
>>>     else
>>>       CFLAGS += -DHAVE_LIBNUMA_SUPPORT
>>> --
>>> 1.8.2.1

