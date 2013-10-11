Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3JKUvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:51:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48544 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab3JKUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:51:11 -0400
Date: Fri, 11 Oct 2013 21:50:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel Kiper <daniel.kiper@oracle.com>, hbabu@us.ibm.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011205016.GA5656@srcf.ucam.org>
References: <20131011154805.GB30181@srcf.ucam.org>
 <CAFLxGvzf1sQy-d03JAnK7eDQdBXrd-zRjcKEbv_x53st5bYELg@mail.gmail.com>
 <20131011163933.GA31941@srcf.ucam.org>
 <CAFLxGvyDYHy-UbZhdQiGvXL=8t0aW8wABc0GRkwVRy8egKJMKw@mail.gmail.com>
 <20131011164400.GA32133@srcf.ucam.org>
 <52582B97.2060907@nod.at>
 <20131011165542.GB32133@srcf.ucam.org>
 <52582E7D.8080909@nod.at>
 <20131011170138.GA32619@srcf.ucam.org>
 <87ob6va670.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob6va670.fsf@tw-ebiederman.twitter.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 01:44:19PM -0700, Eric W. Biederman wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> > No, I manually look up some addresses from /proc/kallsyms and then 
> > modify them in the second kernel.
> 
> An interesting approach I think most of the rest of us would have just
> built a module, or rebuilt our kernels.

Well yeah, but my kernel refuses to load unsigned modules, so.

> Now if this is a backwards argument to remove that silly code path it
> totally fails because now we know the code has not bit-rotted and
> that there are active users.

No, it's not any argument of the kind.

> If you are still pushing the signed-boot agenda I eagerly await your
> patches to make all of this work in a sensible way with signed binaries.

Vivek's working on a separate kexec system call for that, as we agreed 
with Linus at LPC.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
