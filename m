Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaKWQL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:11:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56978 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaKWQLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:11:23 -0500
Date: Sun, 23 Nov 2014 17:11:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Mason <clm@fb.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: New crashes walking proc with Saturday's git
Message-ID: <20141123161120.GB7070@pd.tnic>
References: <20141123010239.GA12691@ret.masoncoding.com>
 <1416758187.24312.12@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416758187.24312.12@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 10:56:27AM -0500, Chris Mason wrote:
> On Sun, Nov 23, 2014 at 10:02 AM, Chris Mason <clm@fb.com> wrote:
> >Since it looks like a race between process exit and /proc, I'll try to
> >hammer on that for a better reproduction.  But, here's hoping that
> >someone has already seen this one:
> 
> It falls over in less than 5 minutes with a fork bomb going.  I'll try to
> bisect.

I'm seeing the same thing:
https://lkml.kernel.org/r/20141123111220.GA6436@pd.tnic

Happens here after I resume from suspend to disk.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
