Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaAIBi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:38:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaAIBi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:38:27 -0500
X-IronPort-AV: E=Sophos;i="4.95,627,1384272000"; 
   d="scan'208";a="9392995"
Message-ID: <52CEB3DF.1000908@cn.fujitsu.com>
Date: Thu, 09 Jan 2014 09:36:15 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, artagnon@gmail.com
Subject: Re: [PATCH 6/8] perf tools: Make --raw-dump work as a proper option
 for perf list.
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com> <a8eee4e15aba50c210ae64aa034bc75b8270b14e.1388416837.git.yangds.fnst@cn.fujitsu.com> <20140108152032.GE2626@infradead.org> <52CDC6D5.9040308@gmail.com>
In-Reply-To: <52CDC6D5.9040308@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:37:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:37:23,
	Serialize complete at 2014/01/09 09:37:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 04:44 PM, David Ahern wrote:
> On 1/8/14, 8:20 AM, Arnaldo Carvalho de Melo wrote:
>> Em Mon, Dec 30, 2013 at 10:26:41AM -0500, Dongsheng Yang escreveu:
>>> >Ramkumar reported that perf list --raw-dump was broken by 44d742e.
>>> >Fix by making raw-dump a proper argument.
>>> >
>>> >Signed-off-by: David Ahern<dsahern@gmail.com>
>> Are you sure David Signed-off-by' this, isn't this just an Acked-by or
>> perhaps a Reviewed-by? David?
>
> I thought the last version of the patch came from Ramkumar.
>
> This version seems like an add-on to the last patch.
>

So, David, do you mind I add "Signed-off-by: David Ahern" in this patch?

> David
>

