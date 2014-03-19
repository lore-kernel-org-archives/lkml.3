Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbaCSPC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:02:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35483 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964911AbaCSPC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:02:57 -0400
Message-ID: <5329B17E.8060303@zytor.com>
Date: Wed, 19 Mar 2014 08:02:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Sarah Newman <srn@prgmr.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Ingo Molnar <mingo@redhat.com>,
        Suresh Siddha <sbsiddha@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com> <531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com> <53266841.6090308@prgmr.com> <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com> <53266D94.70902@prgmr.com> <53266F56.9030909@zytor.com> <5326F89F.8010404@citrix.com> <20140319132156.GA12574@phenom.dumpdata.com>
In-Reply-To: <20140319132156.GA12574@phenom.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 06:21 AM, Konrad Rzeszutek Wilk wrote:
>>
>> The following patch does the always eager allocation.  It's a fixup of
>> Suresh's original patch.
>>
> 
> Hey Peter,
> 
> I think this is the solution you were looking for?
> 
> Or are there some other subtle issues that you think lurk around?
> 

Ah, I managed to miss it (mostly because it was buried *inside* another
email and didn't change the subject line... I really dislike that mode
of delivering a patch.

Let me see if the issues have been fixed.  Still wondering if there is a
way we can get away without the boot_func hack...

	-hpa


