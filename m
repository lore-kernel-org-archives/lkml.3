Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3LJXcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:32:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41658 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab3LJXcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:32:15 -0500
Date: Wed, 11 Dec 2013 00:32:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org,
        toshi.kani@hp.com
Subject: Re: [PATCH v5 00/14] kexec kernel efi runtime support
Message-ID: <20131210233207.GI31437@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:25:49PM -0800, Andrew Morton wrote:
> On Mon,  9 Dec 2013 17:42:13 +0800 Dave Young <dyoung@redhat.com> wrote:
> 
> > Here is the V5 patchset for supporting kexec kernel efi runtime.
> 
> It's unclear (to me) who's supposed to merge this lot.  It's a "kexec"
> patch which actually hits on efi and x86.
> 
> I grabbed them for some -next testing but won't be offended if someone
> else merges them ;)

I was under the impression that this should go through Matt's efi tree.
Oh, and we need to finish reviewing them so picking them up now would be
too premature, IMHO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
