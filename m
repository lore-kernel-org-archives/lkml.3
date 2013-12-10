Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3LJGJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:09:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3LJGJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:09:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,863,1378828800"; 
   d="scan'208";a="9227959"
Message-ID: <52A7667A.3040407@cn.fujitsu.com>
Date: Tue, 10 Dec 2013 14:07:38 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A4AED8.3000506@gmail.com> <20131209180705.GB8098@ghostprotocols.net> <52A60705.5030303@gmail.com> <20131209184901.GE8098@ghostprotocols.net> <52A61D43.6020007@gmail.com> <52A7637E.8080007@cn.fujitsu.com> <52A6AE87.3040706@gmail.com>
In-Reply-To: <52A6AE87.3040706@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 14:09:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 14:09:10,
	Serialize complete at 2013/12/10 14:09:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:02 AM, David Ahern wrote:
> On 12/10/13, 11:54 AM, Dongsheng Yang wrote:
>> Okey, David, I saw your commit 207b57926 (perf kvm: Fix regression with
>> guest machine creation) here. It is applied to fix a bug of SEGFAULT. I
>> have to say that it changed the behavior of report and lead to 
>> current bug.
>
>
> Dongsheng, I appreciate your perseverance here. I am trying to survive 
> this week due to a lot of demands on my time. Next week or the week 
> after I will revisit your questions and comments on perf-kvm.

It is all right to me :).

Thanx !!

Yang
>
> David
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

