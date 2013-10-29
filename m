Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3J2VW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:22:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:4294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab3J2VWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:22:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,596,1378882800"; 
   d="scan'208";a="419351912"
Message-ID: <5270270E.10905@intel.com>
Date: Tue, 29 Oct 2013 22:22:22 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Colin Cross <ccross@android.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Revert 9745cdb36da83aeec198650b410ca06304cf792 ("select: use
 freezable blocking call")?
References: <1383075705.22833.18.camel@x220.thuisdomein>	 <52702170.7080003@intel.com> <1383081359.22833.21.camel@x220.thuisdomein>
In-Reply-To: <1383081359.22833.21.camel@x220.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 10:15 PM, Paul Bolle wrote:
> On Tue, 2013-10-29 at 21:58 +0100, Rafael J. Wysocki wrote:
>> On 10/29/2013 8:41 PM, Paul Bolle wrote:
>>> 4) Should this commit be reverted? Or is there a better fix?
>> In short, yes, it should.
>>
>> I've already queued up a revert of something very similar and I'm going
>> to revert this one too.
> If you do, the revert should go into stable for v3.11+ too, shouldn't
> it?

I'll ask stable to pick it up later (or you can do that too).

Thanks,
Rafael

