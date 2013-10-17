Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab3JQQFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:05:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:59377 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab3JQQFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="scan'208";a="309146754"
Message-ID: <52600A99.2070507@linux.intel.com>
Date: Thu, 17 Oct 2013 09:04:41 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com> <525E9BF7.7020706@linux.intel.com> <525EC6C402000078000FB895@nat28.tlf.novell.com> <525EC73E.3060204@linux.intel.com> <525FCDD702000078000FBBF5@nat28.tlf.novell.com> <52600608.2010704@linux.intel.com> <5260241602000078000FBDD9@nat28.tlf.novell.com>
In-Reply-To: <5260241602000078000FBDD9@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> ... and the non-constant case be taken care of at run time.
> That's precisely what the patch does.

fair enough.

I would like to see a comment above the code to describe this reasoning
and the objective and what the desired behavior is... so that we don't
have to reverse engineer this again 2 years from now ;-)


