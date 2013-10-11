Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3JKQ4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:56:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44723 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3JKQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:56:44 -0400
Date: Fri, 11 Oct 2013 17:56:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, hbabu@us.ibm.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011165622.GC32133@srcf.ucam.org>
References: <20131011110455.GA3626@debian70-amd64.local.net-space.pl>
 <20131011125206.GA2772@redhat.com>
 <20131011153727.GA30181@srcf.ucam.org>
 <20131011154450.GB2772@redhat.com>
 <20131011154805.GB30181@srcf.ucam.org>
 <CAFLxGvzf1sQy-d03JAnK7eDQdBXrd-zRjcKEbv_x53st5bYELg@mail.gmail.com>
 <20131011163933.GA31941@srcf.ucam.org>
 <CAFLxGvyDYHy-UbZhdQiGvXL=8t0aW8wABc0GRkwVRy8egKJMKw@mail.gmail.com>
 <20131011164400.GA32133@srcf.ucam.org>
 <20131011165351.GC2772@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011165351.GC2772@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:53:51PM -0400, Vivek Goyal wrote:
> On Fri, Oct 11, 2013 at 05:44:00PM +0100, Matthew Garrett wrote:
> > I have /dev/mem and a list of addresses I want to modify.
> 
> Why to boot in a second kernel to modify first kernel's RAM. Why not
> do it directly from the first kernel itself (until and unless we want
> first kernel to be stopped while doing those modifications).

Because the kernel in question won't let me do that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
