Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbbAHN52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:57:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59914 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbbAHN51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:57:27 -0500
Date: Thu, 8 Jan 2015 14:57:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86_64,entry: Use sysret to return to userspace when
 possible
Message-ID: <20150108135724.GC20632@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net>
 <49394403b8b12486a6b9c9c70b72bd9f5dce7364.1415403984.git.luto@amacapital.net>
 <20150108122928.GB20632@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150108122928.GB20632@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 01:29:28PM +0100, Borislav Petkov wrote:
> Ok, dammit, it happened again:

Running -rc+ 2without your first two patches doesn't trigger it. Well,
I don't know what workload even triggered it, it used to happen during
system upgrade. I left the box without your patches to build the kernel
in a loop and went to lunch.

Now I'm back and it all still looks good.

I'll try running only with this second patch, i.e. the ret-to-user
SYSRET speedup thing. See what happens.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
