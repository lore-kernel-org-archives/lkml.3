Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3JKPqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab3JKPqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:46:35 -0400
Date: Fri, 11 Oct 2013 11:44:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, hpa@linux.intel.com, keescook@chromium.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, jbeulich@suse.com, keir@xen.org,
        xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011154450.GB2772@redhat.com>
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
 <877gdkce6s.fsf@tw-ebiederman.twitter.com>
 <20131011110455.GA3626@debian70-amd64.local.net-space.pl>
 <20131011125206.GA2772@redhat.com>
 <20131011153727.GA30181@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011153727.GA30181@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 04:37:27PM +0100, Matthew Garrett wrote:
> On Fri, Oct 11, 2013 at 08:52:06AM -0400, Vivek Goyal wrote:
> > On Fri, Oct 11, 2013 at 01:04:55PM +0200, Daniel Kiper wrote:
> > 
> > [..]
> > > > In theory you can swap between to kernels with the preserve_context
> > > > case.  Technically I like the ability but I don't know that it has ever
> > > > achieved much uptake.
> > > 
> > > I think that this is nice idea too. However, I have not seen its usage in real.
> > > Even once there was an idea to remove that stuff from Linux Kernel.
> > 
> > I have not seen anybody using it. I don't even know if it works or not.
> 
> It works. I'm using it.

Hi Matthew,

Just Curious. How is it useful. IOW, what's your use case of booting a new
kernel and then jumping back.

Thanks
Vivek
