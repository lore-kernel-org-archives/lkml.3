Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaFWSJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:09:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48536 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbaFWSJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:09:50 -0400
X-Sasl-enc: NyEfc6NItw6YtrWayPVVp0bj2b3r1bWpd+MbBQ8WxMVM 1403546988
Date: Mon, 23 Jun 2014 14:09:37 -0400
From: Greg KH <greg@kroah.com>
To: Martin Peres <martin.peres@free.fr>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140623180937.GB29494@kroah.com>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
 <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
 <20140621194538.GA4903@kroah.com>
 <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
 <20140623160727.GA19557@kroah.com>
 <CAKb7UvhEMg96YzGuA=rxRDrzBhKiVaYMczrAcm4hA_A4jXAW2w@mail.gmail.com>
 <20140623163600.GB20939@kroah.com>
 <CAKb7Uvgx_1mEPapJF3V5s8vUViGnRGCerkixwdTv_EpHhEozBg@mail.gmail.com>
 <53A867DB.90604@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A867DB.90604@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 07:46:03PM +0200, Martin Peres wrote:
> Le 23/06/2014 18:40, Ilia Mirkin a écrit :
> >On Mon, Jun 23, 2014 at 12:36 PM, Greg KH <greg@kroah.com> wrote:
> >>On Mon, Jun 23, 2014 at 12:18:51PM -0400, Ilia Mirkin wrote:
> >>A list of valid "values" that a file can be in is fine if you just then
> >>write one value back to that file.  That's the one exception, but a
> >>minor one given the huge number of sysfs files.  Other than that, if you
> >
> >Which is pretty much what the pstate file is. Would it make things
> >better if we removed the descriptive info while leaving the pstate
> >file in place?
> 
> This means we should also create a new sysfs file per performance level too,
> right? Is there another way for a driver to expose a list in sysfs?

What exactly are you wanting to export to userspace?  What will
userspace do with this information?  Why export anything at all?

Start with defining that, and go from there.

thanks,

greg k-h
