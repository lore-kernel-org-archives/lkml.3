Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234Ab3JPRFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:05:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:20935 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab3JPRFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="375641098"
Message-ID: <525EC73E.3060204@linux.intel.com>
Date: Wed, 16 Oct 2013 10:05:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com> <525E9BF7.7020706@linux.intel.com> <525EC6C402000078000FB895@nat28.tlf.novell.com>
In-Reply-To: <525EC6C402000078000FB895@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> if you have found cases where this matters... maybe you found a new security
>> issue...
>
> Iirc I could convince myself that in the cited cases the warnings
> were there for no reason.

can you pick one on a source level ?
(and the gcc 4.6 had a few false positives which is why it got disabled there)

