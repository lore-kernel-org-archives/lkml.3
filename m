Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3GHID7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:03:59 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:51228 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3GHID5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:03:57 -0400
Message-ID: <51DA726A.8090108@kernel.org>
Date: Mon, 08 Jul 2013 11:03:54 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab: Sharing s_next and s_stop between slab and
 slub
References: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372069394-26167-2-git-send-email-liwanp@linux.vnet.ibm.com> <alpine.DEB.2.02.1306241421560.25343@chino.kir.corp.google.com> <0000013f9aeb70c6-f6dad22c-bb88-4313-8602-538a3f5cedf5-000000@email.amazonses.com> <CAOJsxLGXTcB2iVcg5SArVytakjeTSCZqLEqnBWhTrjA4aLnSSQ@mail.gmail.com> <20130708001644.GA18895@hacker.(null)>
In-Reply-To: <20130708001644.GA18895@hacker.(null)>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 03:16 AM, Wanpeng Li wrote:
> On Sun, Jul 07, 2013 at 07:41:54PM +0300, Pekka Enberg wrote:
>> On Mon, Jul 1, 2013 at 6:48 PM, Christoph Lameter <cl@linux.com> wrote:
>>> On Mon, 24 Jun 2013, David Rientjes wrote:
>>>
>>>> On Mon, 24 Jun 2013, Wanpeng Li wrote:
>>>>
>>>>> This patch shares s_next and s_stop between slab and slub.
>>>>>
>>>>
>>>> Just about the entire kernel includes slab.h, so I think you'll need to
>>>> give these slab-specific names instead of exporting "s_next" and "s_stop"
>>>> to everybody.
>>>
>>> He put the export into mm/slab.h. The headerfile is only included by
>>> mm/sl?b.c .
>>
>> But he then went on to add globally visible symbols "s_next" and
>> "s_stop" which is bad...
>>
>> Please send me an incremental patch on top of slab/next to fix this
>> up. Otherwise I'll revert it before sending a pull request to Linus.
>
> I attach the incremental patch in attachment. ;-)

Applied, thanks!

			Pekka

