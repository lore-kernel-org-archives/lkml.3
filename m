Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3GGPiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 11:38:50 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:50597 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab3GGPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 11:38:49 -0400
Message-ID: <51D98B84.4000607@kernel.org>
Date: Sun, 07 Jul 2013 18:38:44 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm/slab: Fix drain freelist excessively
References: <1372898006-6308-1-git-send-email-liwanp@linux.vnet.ibm.com> <0000013faf0d3958-00e5e945-25d8-43c1-ac6e-3d3ad69b2718-000000@email.amazonses.com> <20130707092448.GA11177@hacker.(null)>
In-Reply-To: <20130707092448.GA11177@hacker.(null)>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/7/13 12:24 PM, Wanpeng Li wrote:
> On Fri, Jul 05, 2013 at 01:37:28PM +0000, Christoph Lameter wrote:
>> On Thu, 4 Jul 2013, Wanpeng Li wrote:
>>
>>> This patch fix the callers that pass # of objects. Make sure they pass #
>>> of slabs.
>>
>> Acked-by: Christoph Lameter <cl@linux.com>
>
> Hi Pekka,
>
> Is it ok for you to pick this patchset? ;-)

Applied, thanks a lot!

