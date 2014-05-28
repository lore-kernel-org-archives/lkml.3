Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaE1UKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:10:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755299AbaE1UKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:10:45 -0400
Date: Wed, 28 May 2014 15:11:25 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Dave Young <dyoung@redhat.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140528201125.GZ10771@sgi.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
 <20140528094712.GL2820@darkstar.nay.redhat.com>
 <20140528155104.GW10771@sgi.com>
 <20140528190400.GR14863@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528190400.GR14863@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:04:00PM -0400, Vivek Goyal wrote:
> On Wed, May 28, 2014 at 10:51:04AM -0500, Alex Thorlton wrote:
> 
> [..]
> > A side note, though:  We're going to have to figure out some way to
> > determine whether or not to apply the old_map quirk on during boot
> > anyway, so if it's easiest for you to just determine how the original
> > kernel was booted and key off of that, then I wouldn't worry about
> > finding a different method to get the firmware version in userspace,
> > unless there are other reasons for you to do it that way.
> 
> Agreed. Let kernel and firmware figure it out when to apply quirk and
> user space should not worry about firmware version.
> 
> I liked the other approach better where user space just needs to know
> if 1:1 mapping are in effect or not and take decision based on that.
> 
> So once SGI firmware gets fixed for 1:1 mapping, and kernel knows it,
> then user space will not have to be changed at all.

Sounds good to me.  Working on a potential kernel fix as we speak.

- Alex
