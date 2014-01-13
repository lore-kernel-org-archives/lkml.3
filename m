Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaAMIFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:05:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34817 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaAMIFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:05:34 -0500
X-IronPort-AV: E=Sophos;i="4.95,651,1384272000"; 
   d="scan'208";a="9409353"
Message-ID: <52D45498.3030608@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 16:03:20 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, artagnon@gmail.com
Subject: Re: [PATCH 6/8] perf tools: Make --raw-dump work as a proper option
 for perf list.
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com> <a8eee4e15aba50c210ae64aa034bc75b8270b14e.1388416837.git.yangds.fnst@cn.fujitsu.com> <20140108152032.GE2626@infradead.org> <52CDC6D5.9040308@gmail.com> <52CEB3DF.1000908@cn.fujitsu.com> <52D01215.7010004@gmail.com>
In-Reply-To: <52D01215.7010004@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/13 16:04:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/13 16:04:23,
	Serialize complete at 2014/01/13 16:04:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 10:30 AM, David Ahern wrote:
> On 1/9/14, 7:36 AM, Dongsheng Yang wrote:
>> On 01/08/2014 04:44 PM, David Ahern wrote:
>>> On 1/8/14, 8:20 AM, Arnaldo Carvalho de Melo wrote:
>>>> Em Mon, Dec 30, 2013 at 10:26:41AM -0500, Dongsheng Yang escreveu:
>>>>> >Ramkumar reported that perf list --raw-dump was broken by 44d742e.
>>>>> >Fix by making raw-dump a proper argument.
>>>>> >
>>>>> >Signed-off-by: David Ahern<dsahern@gmail.com>
>>>> Are you sure David Signed-off-by' this, isn't this just an Acked-by or
>>>> perhaps a Reviewed-by? David?
>>>
>>> I thought the last version of the patch came from Ramkumar.
>>>
>>> This version seems like an add-on to the last patch.
>>>
>>
>> So, David, do you mind I add "Signed-off-by: David Ahern" in this patch?
>
> I didn't write it and content wise very little comes from me.
>

Okey, David, thanx for your reply. I will remove this line in my patch 
next version.

> David
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

