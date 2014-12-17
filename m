Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaLQVTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:19:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56695 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaLQVTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:19:16 -0500
Date: Wed, 17 Dec 2014 22:19:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Calvin Owens <calvinowens@fb.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Message-ID: <20141217211912.GC8457@pd.tnic>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
 <20141209180835.GF3990@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
 <20141210031102.GB1437888@mail.thefacebook.com>
 <20141210192340.GF17053@pd.tnic>
 <20141211023438.GA3239919@mail.thefacebook.com>
 <20141211144313.GB31140@pd.tnic>
 <20141217001711.GA7152@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141217001711.GA7152@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 04:17:11PM -0800, Calvin Owens wrote:
> > Right, I guess we could do something similar to what you proposed
> > already (diff below ontop of my previous diff).
> 
> That looks good, thanks :)

Ok, thanks. I'll try to give it a run once I get a quiet minute from all
the CVE fun recently.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
