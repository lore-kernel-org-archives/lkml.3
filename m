Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab3D3Uue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:50:34 -0400
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:57361 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933665Ab3D3Uu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:50:28 -0400
Date: Tue, 30 Apr 2013 20:50:26 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
In-Reply-To: <1367348457.27102.197.camel@schen9-DESK>
Message-ID: <0000013e5cb5ec6a-04ce1f4a-c4b9-430f-8235-69e92482faad-000000@email.amazonses.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com> <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com> <1367339009.27102.174.camel@schen9-DESK>
 <0000013e5bfd1548-a6ef7962-7b00-495b-8e83-d7a08413e165-000000@email.amazonses.com> <1367344094.27102.182.camel@schen9-DESK> <0000013e5c1377c5-49a8fca5-eb04-4e3a-a507-ce3a47fea685-000000@email.amazonses.com> <1367344522.27102.184.camel@schen9-DESK>
 <0000013e5c32f7fd-b4bf1b22-7924-42b5-b835-eb2b5926bbf6-000000@email.amazonses.com> <1367348457.27102.197.camel@schen9-DESK>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Tim Chen wrote:

> Will it be acceptable if I make the per cpu counter list under
> CONFIG_CPU_HOTPLUG default? I will need the list to go through all
> counters to update the batch value sizes.  The alternative will be to
> make the configurable batch option only available under
> CONFIG_HOTPLUG_CPU.

Make the list default. Could be useful elsewhere.
