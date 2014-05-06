Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaEFRMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:12:16 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:36871 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaEFRMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:12:14 -0400
Message-ID: <536917EB.60605@hp.com>
Date: Tue, 06 May 2014 10:12:11 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: josh@joshtriplett.org, David Miller <davem@davemloft.net>
CC: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
References: <20140506032114.GP2382@two.firstfloor.org> <20140505.232327.578134514220748085.davem@davemloft.net> <20140506155703.GA20391@cloud> <20140506.115941.428706504757835279.davem@davemloft.net> <20140506164108.GA20536@cloud>
In-Reply-To: <20140506164108.GA20536@cloud>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 09:41 AM, josh@joshtriplett.org wrote:
> On Tue, May 06, 2014 at 11:59:41AM -0400, David Miller wrote:
>> Making 2MB RAM machines today makes no sense at all.
>>
>> The lowest end dirt cheap smartphone, something which fits on
>> someone's pocket, has gigabytes of ram.
>
> The lowest-end smartphone isn't anywhere close to "dirt cheap", and
> hardly counts as "embedded" at all anymore.  Smartphones cost $100+;
> we're talking about systems in the low tens of dollars or less.  These
> systems will have no graphics, no peripherals, and only one or two
> specific functions.  The entirety of their functionality will likely
> consist of a single userspace program; they might not even have a PID 2.
> *That's* the kind of "embedded" we're talking about, not the
> supercomputers we carry around in our pockets.

Would this be some sort of "Internet of Things" system?

rick jones
