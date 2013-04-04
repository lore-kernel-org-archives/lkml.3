Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344Ab3DDQl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:41:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45261 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763296Ab3DDQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:41:54 -0400
Message-ID: <515DAD4D.9020100@wwwdotorg.org>
Date: Thu, 04 Apr 2013 10:41:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH V2 4/7] kbuild: always run gcc -E on *.dts, remove cmd_dtc_cpp
References: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org> <1365032098-22825-4-git-send-email-swarren@wwwdotorg.org> <515CC317.2000703@elopez.com.ar>
In-Reply-To: <515CC317.2000703@elopez.com.ar>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 06:02 PM, Emilio López wrote:
> Hi Stephen,
> 
> El 03/04/13 20:34, Stephen Warren escribió:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Replace cmd_dtc with cmd_dtc_cpp, and delete the latter.
>>
>> Previously, a special file extension (.dtsp) was required to trigger
>> the C pre-processor to run on device tree files. This was ugly. Now that
>> previous changes have enhanced cmd_dtc_cpp to collect dependency
>> information from both gcc -E and dtc, we can transparently run the pre-
>> processor on all device tree files, irrespective of whether they
>>
> 
> I think a line got dropped on the commit description by mistake.

Thanks for noticing. I've locally added the following line to the end of
the description, but won't repost unless there's some other reason, or
the series is ack'd enough to actually be applied:

use /include/ or #include syntax to include *.dtsi.

