Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaCaXzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:55:55 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59216 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbaCaXzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:55:54 -0400
X-Sasl-enc: 6GfG8x7/WNRvfUHfpXgnLfAigyWCeIXphDZcgvMJ7zla 1396310152
Date: Mon, 31 Mar 2014 16:58:12 -0700
From: Greg KH <greg@kroah.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Feb. Fedora Kernel Patch Report
Message-ID: <20140331235812.GD20979@kroah.com>
References: <CA+5PVA6dz2ixLfHOHytkis6XmxdLKXZp9x8rEjB=pedrg7sXJQ@mail.gmail.com>
 <20140325212417.GA6545@kroah.com>
 <CA+5PVA608SPM1r5tXwo_C+vaEff+XiLQ5AWwH7-i-MMGcXtuHw@mail.gmail.com>
 <5332E977.8010102@suse.cz>
 <20140326211637.GB20108@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326211637.GB20108@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 02:16:38PM -0700, Michal Hocko wrote:
> On Wed 26-03-14 15:51:35, Jiri Slaby wrote:
> > On 03/26/2014 02:44 PM, Josh Boyer wrote:
> > > On Tue, Mar 25, 2014 at 5:24 PM, Greg KH <greg@kroah.com> wrote:
> > >> On Fri, Feb 28, 2014 at 10:13:29AM -0500, Josh Boyer wrote:
> > >>> cgroup-fixes.patch (rhbz 1045755)
> > >>> - Upstream commits 0ab02ca8f887908152d1a96db5130fc661d36a1e
> > >>> - There was a 3.12 version of this patch sent to stable list from
> > >>> Michal Hocko.  I don't remember why it wasn't applied, or why it
> > >>> wasn't applied for 3.13.y...
> > >>
> > >> It didn't apply to 3.13, and I think I was waiting for a backported
> > >> version, do you have one?
> > > 
> > > As far as I know we're using this version:
> > > 
> > > http://thread.gmane.org/gmane.linux.kernel.cgroups/10336/focus=1646465
> > > 
> > > The commentary on the thread seems to imply that Michal was going to
> > > send it again for some reason.  Michal, did you send the 3.12/3.13
> > > backport for this commit directly to stable?
> > 
> > In the meantime, I applied to the stable 3.12 Michal's version from suse
> > enterprise 12. I believe that it is the same as in the link above.
> > Please confirm.
> 
> Do not remember why it didn't end up in the stable back then but yes the
> fix you have queued up seems to be the right one.

Thanks, I've picked that one up now.

greg k-h
