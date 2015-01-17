Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbbARABM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:01:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbARABJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:01:09 -0500
Date: Sat, 17 Jan 2015 15:54:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: lustre/lnet/lnet/lib-move.c: memcpy with (struct
 iovec*)->iov_base, which is __user
Message-ID: <20150117235458.GA23280@kroah.com>
References: <CANZNk80SoQZU994psVKuuGRGGHnGgO7bcFpPBQoGyg=CjW77xw@mail.gmail.com>
 <20150107083654.GK15033@mwanda>
 <D0D2667E.D2C25%andreas.dilger@intel.com>
 <CANZNk83Y5T75H86VZ4dMVigPiaVADZB60yc6QWWCWdJ=SdT+sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANZNk83Y5T75H86VZ4dMVigPiaVADZB60yc6QWWCWdJ=SdT+sQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 02:28:12PM +0200, Andrey Utkin wrote:
> 2015-01-07 13:32 GMT+02:00 Dilger, Andreas <andreas.dilger@intel.com>:
> > On 2015/01/07, 1:36 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:
> >> Didn't Al change these to kvec instead of iovec?  You have to look at
> >> the callers to figure out if it's actually a user space pointer or a
> >> kernel pointer.
> >
> > A patch was sent by Al on Dec 2 to replace iovec with kvec, in a thread
> > titled "[PATCH] staging:lustre:lnet: Incorrect type in assignment".  Greg
> > replied on Dec 10 in another thread (also fixing this same warning) titled
> > "[PATCH] staging: lustre: Fix the warning messages about casting without
> > __user macro" that Al's patch was in the staging tree for 3.19-rc1.
> 
> In current linux-next, I see none of the mentioned patches. Also I
> don't see them mentioned in GKH's merge commit "Merge tag
> 'staging-3.19-rc1'..."
> Is it ok?

Al's patch is now merged.
