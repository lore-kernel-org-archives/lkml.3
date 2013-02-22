Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab3BVOFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:05:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab3BVOFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:05:51 -0500
Date: Fri, 22 Feb 2013 09:05:40 -0500
From: Peter Jones <pjones@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, David Howells <dhowells@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130222140539.GE20629@fenchurch.internal.datastacks.com>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
 <20130221174955.GA20886@srcf.ucam.org>
 <CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxZ4f4KiHQBCAgTghm+deniS6rDz4wna9bce6vK8WppsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:03:20AM -0800, Linus Torvalds wrote:
> Besides, let's face it, Red Hat is going to sign the official nVidia
> and AMD binary modules anyway. Don't even bother to pretend anything
> else.

I just want to make sure this doesn't go unresponded to - Red Hat
will not sign kernel modules built by an outside source. We're simply
not going to sign these kernel modules. That's one of the big reasons
we want a setup where they can sign their own modules in the first place.

-- 
        Peter
