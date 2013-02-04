Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3BDUtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:49:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60829 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3BDUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:49:05 -0500
Message-ID: <51101EBD.80607@wwwdotorg.org>
Date: Mon, 04 Feb 2013 13:49:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Joseph Lo <josephl@nvidia.com>
Subject: Re: CPU hotplug hang due to "swap: make each swap partition have
 one address_space"
References: <510C9DE9.9040207@wwwdotorg.org> <20130204023646.GA321@kernel.org> <510FE866.9090600@wwwdotorg.org>
In-Reply-To: <510FE866.9090600@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 09:57 AM, Stephen Warren wrote:
> On 02/03/2013 07:36 PM, Shaohua Li wrote:
>> On Fri, Feb 01, 2013 at 10:02:33PM -0700, Stephen Warren wrote:
>>> Shaohua,
>>>
>>> In next-20130128, commit 174f064 "swap: make each swap partition have
>>> one address_space" (from the mm/akpm tree) appears causes a hang/RCU
>>> stall for me when hot-unplugging a CPU.
>>
>> does this one work for you?
>> http://marc.info/?l=linux-mm&m=135929599505624&w=2
>> Or try a more recent linux-next. The patch is in akpm's tree.
> 
> Yes, that patch fixes the issue for me, thanks.

I notice this patch is only in Andrew's mmots tree, not mmotm, and hence
isn't included in linux-next. Do you know when it'll be "promoted" and
show up in linux-next?
