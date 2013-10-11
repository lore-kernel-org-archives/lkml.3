Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3JKRCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:02:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44794 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3JKRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:02:22 -0400
Date: Fri, 11 Oct 2013 18:01:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Weinberger <richard@nod.at>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, hbabu@us.ibm.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011170138.GA32619@srcf.ucam.org>
References: <20131011153727.GA30181@srcf.ucam.org>
 <20131011154450.GB2772@redhat.com>
 <20131011154805.GB30181@srcf.ucam.org>
 <CAFLxGvzf1sQy-d03JAnK7eDQdBXrd-zRjcKEbv_x53st5bYELg@mail.gmail.com>
 <20131011163933.GA31941@srcf.ucam.org>
 <CAFLxGvyDYHy-UbZhdQiGvXL=8t0aW8wABc0GRkwVRy8egKJMKw@mail.gmail.com>
 <20131011164400.GA32133@srcf.ucam.org>
 <52582B97.2060907@nod.at>
 <20131011165542.GB32133@srcf.ucam.org>
 <52582E7D.8080909@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52582E7D.8080909@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 06:59:41PM +0200, Richard Weinberger wrote:
> Am 11.10.2013 18:55, schrieb Matthew Garrett:
> > On Fri, Oct 11, 2013 at 06:47:19PM +0200, Richard Weinberger wrote:
> > 
> >> But you still need a magic tool which create you this list.
> > 
> > I just read /proc/kallsyms. I'm really not doing anything complicated.
> > 
> >> If you have a tool which takes two kernel images and create such
> >> a delta, fine.
> > 
> > Isn't that ksplice?
> 
> So, you have a variant of ksplice which is able to kexec?

No, I manually look up some addresses from /proc/kallsyms and then 
modify them in the second kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
