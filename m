Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab3KVGBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:01:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3KVGBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:01:02 -0500
X-IronPort-AV: E=Sophos;i="4.93,750,1378828800"; 
   d="scan'208";a="9100177"
Message-ID: <528FA98E.4080708@cn.fujitsu.com>
Date: Fri, 22 Nov 2013 13:59:26 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: David Ahern <dsahern@gmail.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf util: optimize util/machine.c:machines__find().
References: <1385069470-22692-1-git-send-email-yangds.fnst@cn.fujitsu.com> <528E782A.9010509@gmail.com> <20131122000608.GA2117@ghostprotocols.net>
In-Reply-To: <20131122000608.GA2117@ghostprotocols.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/22 13:58:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/22 13:59:01,
	Serialize complete at 2013/11/22 13:59:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/21/2013 07:06 PM, Arnaldo Carvalho de Melo wrote:
>
>> This changes machines__find to always return the machine for the
>> host (pid == 0). This function is also used for VM lookups.
> Nope:
>
> /* Native host kernel uses -1 as pid index in machine */
> #define HOST_KERNEL_ID                  (-1)
> #define DEFAULT_GUEST_KERNEL_ID         (0)
>
> But I fail to see the point of the "optimization", we're looking for a
> pid, not always for '0'.
>
> And the changelog is horrible, why is it "unnecessary"? Please don't be
> so terse :-)
>
> - Arnaldo
>

Hi David and Arnaldo,

     It is my mistake about it!! The original code does the right thing.
     Sorry to bother you, I am a newbie for perf.
     I will send a patch after second and third thought next time.

Thanx for your reply.

- Yang


