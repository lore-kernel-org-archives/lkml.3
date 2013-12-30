Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3L3DAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 22:00:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53342 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab3L3DAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 22:00:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,571,1384272000"; 
   d="scan'208";a="9348408"
Message-ID: <52C19209.7060404@cn.fujitsu.com>
Date: Mon, 30 Dec 2013 10:32:25 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        namhyung.kim@lge.com, jolsa@redhat.com
Subject: Re: [PATCH 0/7 V2] Add support of user space symboles for guest.
References: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com> <52B45BF6.1060701@gmail.com>
In-Reply-To: <52B45BF6.1060701@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:33:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:34:02,
	Serialize complete at 2013/12/30 10:34:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 10:02 AM, David Ahern wrote:
> On 12/20/13, 1:52 PM, Dongsheng Yang wrote:
>> Hi Arnaldo:
>>     Please help to review this patchset.
>>
>> Changelog:
>>     - v2:
>>         * splite the first commit.
>>
>
> At best you are creating knowledge of running tasks in the VMs when 
> the perf session is started. That's it. That information cannot be 
> used since the host has no idea what task is running in a VM at any 
> given moment. No insight into process creation, mmaps, exits, etc.
>

Yes, you are right. host has no idea what task is running in a VM.

Thanx for your reply.

Yang
> David
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

