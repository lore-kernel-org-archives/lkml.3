Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaKWQ75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:59:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50579 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaKWQ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:59:56 -0500
Date: Sun, 23 Nov 2014 17:59:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Mason <clm@fb.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: New crashes walking proc with Saturday's git
Message-ID: <20141123165953.GC6436@pd.tnic>
References: <20141123010239.GA12691@ret.masoncoding.com>
 <1416758187.24312.12@mail.thefacebook.com>
 <20141123161120.GB7070@pd.tnic>
 <1416759411.24312.13@mail.thefacebook.com>
 <20141123163258.GB6436@pd.tnic>
 <1416761342.24312.15@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416761342.24312.15@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 11:49:02AM -0500, Chris Mason wrote:
> I've adding Ingo and Stanislaw to the cc.  With
> 6e998916dfe327e785e7c2447959b2c1a3ea4930 reverted, I'm no longer crashing.

Ok, reverting here too, to confirm.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
