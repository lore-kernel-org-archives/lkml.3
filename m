Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab3D3TEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:04:46 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:39871 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab3D3TEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:04:44 -0400
Date: Tue, 30 Apr 2013 12:04:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
Message-ID: <20130430190435.GF19814@mtj.dyndns.org>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
 <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com>
 <1367339009.27102.174.camel@schen9-DESK>
 <0000013e5bfd1548-a6ef7962-7b00-495b-8e83-d7a08413e165-000000@email.amazonses.com>
 <1367344094.27102.182.camel@schen9-DESK>
 <0000013e5c1377c5-49a8fca5-eb04-4e3a-a507-ce3a47fea685-000000@email.amazonses.com>
 <1367344522.27102.184.camel@schen9-DESK>
 <0000013e5c32f7fd-b4bf1b22-7924-42b5-b835-eb2b5926bbf6-000000@email.amazonses.com>
 <1367348457.27102.197.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367348457.27102.197.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 30, 2013 at 12:00:57PM -0700, Tim Chen wrote:
> Will it be acceptable if I make the per cpu counter list under
> CONFIG_CPU_HOTPLUG default? I will need the list to go through all
> counters to update the batch value sizes.  The alternative will be to
> make the configurable batch option only available under
> CONFIG_HOTPLUG_CPU.

I haven't looked at the patch but making cpu counter list default
regardless of hotplug cpu should be okay.  Most modern configurations,
even most embedded ones, enable CPU hotplug for PM anyway.

Thanks.

-- 
tejun
