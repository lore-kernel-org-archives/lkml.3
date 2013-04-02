Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079Ab3DBSd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:33:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45089 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760910Ab3DBSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:33:25 -0400
Date: Tue, 02 Apr 2013 14:33:19 -0400 (EDT)
Message-Id: <20130402.143319.1782388191427921383.davem@davemloft.net>
To: robherring2@gmail.com
Cc: linux@roeck-us.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        rob.herring@calxeda.com, david.daney@cavium.com
Subject: Re: [PATCH] of_net.h: Provide dummy functions if OF_NET is not
 configured
From: David Miller <davem@davemloft.net>
In-Reply-To: <5159DC82.3050804@gmail.com>
References: <5159D588.5070603@gmail.com>
	<20130401190100.GA1042@roeck-us.net>
	<5159DC82.3050804@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 02 Apr 2013 11:33:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robherring2@gmail.com>
Date: Mon, 01 Apr 2013 14:14:10 -0500

> On 04/01/2013 02:01 PM, Guenter Roeck wrote:
>> On Mon, Apr 01, 2013 at 01:44:24PM -0500, Rob Herring wrote:
>>> On 04/01/2013 01:19 PM, Guenter Roeck wrote:
>>>> of_get_mac_address() and of_get_phy_mode() are only provided if OF_NET
>>>> is configured. While most callers check for the define, not all do, and those
>>>> who do require #ifdef around the code. For those who don't, the missing check
>>>> can result in errors such as
>>>
>>> How about removing the ifdef from those callers?
>>>
>> That would be the next step, after/if this one is accepted.
>> If not, it doesn't make sense to waste my time.
> 
> Assuming that is done:
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
> Presumably with the follow-on patches, this can go in thru the net tree.

Indeed, please resubmit this with the follow-on cleanups.

Thanks.
