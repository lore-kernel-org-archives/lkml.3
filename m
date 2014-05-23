Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaEWV2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:28:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50579 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbaEWV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:28:18 -0400
X-Sasl-enc: KHk6c6Pz49DzMFQ7Trc1Us3pKOTgAO7b7a+bj/Sd51fW 1400880497
Message-ID: <537FBD6F.1070009@iki.fi>
Date: Sat, 24 May 2014 00:28:15 +0300
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: slab_common: fix the check for duplicate slab names
References: <alpine.LRH.2.02.1403041711300.29476@file01.intranet.prod.int.rdu2.redhat.com> <20140325170324.GC580@redhat.com> <alpine.DEB.2.10.1403251306260.26471@nuc> <20140523201632.GA16013@redhat.com>
In-Reply-To: <20140523201632.GA16013@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 11:16 PM, Mike Snitzer wrote:
> On Tue, Mar 25 2014 at  2:07pm -0400,
> Christoph Lameter <cl@linux.com> wrote:
>
>> On Tue, 25 Mar 2014, Mike Snitzer wrote:
>>
>>> This patch still isn't upstream.  Who should be shepherding it to Linus?
>> Pekka usually does that.
>>
>> Acked-by: Christoph Lameter <cl@linux.com>
> This still hasn't gotten upstream.
>
> Pekka, any chance you can pick it up?  Here it is in dm-devel's
> kernel.org patchwork: https://patchwork.kernel.org/patch/3768901/
>
> (Though it looks like it needs to be rebased due to the recent commit
> 794b1248, should Mikulas rebase and re-send?)

I applied it and fixed the conflict by hand.

Please double-check commit 694617474e33b8603fc76e090ed7d09376514b1a in 
my tree:

https://git.kernel.org/cgit/linux/kernel/git/penberg/linux.git/

- Pekka
