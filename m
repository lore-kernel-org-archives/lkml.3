Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224Ab3IDHqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:46:50 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:41559 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3IDHqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:46:48 -0400
Message-ID: <5226E55A.3000705@synopsys.com>
Date: Wed, 4 Sep 2013 13:16:34 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 32/35] arc: Replace __get_cpu_var uses
References: <20130828193457.140443630@linux.com> <00000140c6781cab-d0df0392-b65b-4213-8be0-1e4a04f67fb2-000000@email.amazonses.com> <C2D7FE5348E1B147BCA15975FBA23075140F60@IN01WEMBXA.internal.synopsys.com> <00000140caf51d3b-0c5ebca6-f4a7-49b8-94c8-fc8b0bde04b8-000000@email.amazonses.com>
In-Reply-To: <00000140caf51d3b-0c5ebca6-f4a7-49b8-94c8-fc8b0bde04b8-000000@email.amazonses.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 08/29/2013 10:13 PM, Christoph Lameter wrote:
> On Thu, 29 Aug 2013, Vineet Gupta wrote:
> 
>> On 08/29/2013 01:18 AM, Christoph Lameter wrote:
>>> Acked-by: Vineet Gupta <vgupta@synopsys.com>
>>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>
>> Applied to for-next.
> 
> Ok dropping it from patchset.
> 

Considering other discussions on this thread, shall I drop this from my for-curr
for this merge window ? I don't see any other arch changes to that effect in
latest linux-next.

-Vineet


