Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3EHOBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:01:15 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37765 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab3EHOBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:01:12 -0400
Message-ID: <518A5A9D.8090503@linux.vnet.ibm.com>
Date: Wed, 08 May 2013 22:01:01 +0800
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH] perf tools: Fix perf version generation
References: <1368006214-12912-1-git-send-email-rric@kernel.org> <518A2B4B.4040509@linux.vnet.ibm.com> <20130508110611.GA8356@rric.localhost>
In-Reply-To: <20130508110611.GA8356@rric.localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050813-1618-0000-0000-000003DA918E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 07:06 PM, Robert Richter wrote:
> On 08.05.13 18:39:07, Xiao Guangrong wrote:
I remember that Wang has posted a similar patch to fix this bug several
>> weeks ago:
http://lkml.org/lkml/2013/4/24/70
>>
>> But have no response yet.
>
> Yes, this patch would fix the version tag too.
>
> The patch I wrote also reports a commit id even in the case when no
> tag is found. This was the original reason why I stumbled over this.
> Assume a repository for testing there you just push the commit id to.
> This does not contain any tags but a valid commit id. Now, it
> determines the version tag from the makefile but does not drop the
> commit id.
>
> -Robert
>
Hi, Robert,

for http://lkml.org/lkml/2013/4/24/70
I download linux-3.9.1.tar.xz(no git repo) and apply my patch, it works:

# ./perf --version
perf version 3.9.1

your patch works when the repo only has commit info but no tags info, 
but I confuse that whether this situation is Real?

Maybe you prepare for a RARE case but increase the code's **Complexity** ?

thanks

