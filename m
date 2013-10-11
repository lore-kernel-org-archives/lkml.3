Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3JKMwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3JKMwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:52:43 -0400
Date: Fri, 11 Oct 2013 08:52:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: ebiederm@xmission.com, hbabu@us.ibm.com, hpa@linux.intel.com,
        keescook@chromium.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
Subject: Re: kexec: Clearing registers just before jumping into purgatory
Message-ID: <20131011125206.GA2772@redhat.com>
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
 <877gdkce6s.fsf@tw-ebiederman.twitter.com>
 <20131011110455.GA3626@debian70-amd64.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011110455.GA3626@debian70-amd64.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 01:04:55PM +0200, Daniel Kiper wrote:

[..]
> > In theory you can swap between to kernels with the preserve_context
> > case.  Technically I like the ability but I don't know that it has ever
> > achieved much uptake.
> 
> I think that this is nice idea too. However, I have not seen its usage in real.
> Even once there was an idea to remove that stuff from Linux Kernel.

I have not seen anybody using it. I don't even know if it works or not. If
nobody is using it, I will advocate removing it. It introduces extra
complexity and makes new code changes more difficult.

Thanks
Vivek
