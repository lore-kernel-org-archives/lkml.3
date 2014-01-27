Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaA0RCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:02:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:28735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaA0RCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:02:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,730,1384329600"; 
   d="scan'208";a="473220225"
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Michael Matz <matz@suse.de>, Michal Hocko <mhocko@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
References: <20140127163758.GC6839@pd.tnic> <52E68C25.1070804@zytor.com>
	<alpine.LNX.2.00.1401271742300.14101@pobox.suse.cz>
Date: Mon, 27 Jan 2014 09:01:38 -0800
In-Reply-To: <alpine.LNX.2.00.1401271742300.14101@pobox.suse.cz> (Jiri
	Kosina's message of "Mon, 27 Jan 2014 17:43:51 +0100 (CET)")
Message-ID: <87ha8pqryl.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Mon, 27 Jan 2014, H. Peter Anvin wrote:
>
>> I don't think it'd hurt... although I think the above pretty much
>> requires that the code contain actual floating-point types to ever be
>> generated.  
>
> Unfortunately using float-typed constants (such as 1EexpL) are enough for 
> this to happen.

checkpatch would seem to be the right place to check for this?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
