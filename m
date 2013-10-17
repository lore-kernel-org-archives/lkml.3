Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3JQQI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:08:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52683 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab3JQQI2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 17 Oct 2013 12:08:28 -0400
Message-Id: <5260279702000078000FBDE8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 17 Oct 2013 17:08:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com>
 <525E9BF7.7020706@linux.intel.com>
 <525EC6C402000078000FB895@nat28.tlf.novell.com>
 <525EC73E.3060204@linux.intel.com>
 <525FCDD702000078000FBBF5@nat28.tlf.novell.com>
 <52600608.2010704@linux.intel.com>
 <5260241602000078000FBDD9@nat28.tlf.novell.com>
 <52600A99.2070507@linux.intel.com>
In-Reply-To: <52600A99.2070507@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.10.13 at 18:04, Arjan van de Ven <arjan@linux.intel.com> wrote:
>> 
>> ... and the non-constant case be taken care of at run time.
>> That's precisely what the patch does.
> 
> fair enough.
> 
> I would like to see a comment above the code to describe this reasoning
> and the objective and what the desired behavior is... so that we don't
> have to reverse engineer this again 2 years from now ;-)

Will do, and then perhaps mirror the whole behavior to
copy_to_user().

Jan

