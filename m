Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3CDHsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:48:35 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47950 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab3CDHsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:48:33 -0500
Date: Mon, 4 Mar 2013 15:48:50 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Henningsson <david.henningsson@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
        akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 093/153] ALSA: hda - hdmi: Make jacks phantom, if theyre not
 detectable
Message-ID: <20130304074850.GA1136@kroah.com>
References: <20130304033716.795093499@decadent.org.uk>
 <1362374037.3768.298.camel@deadeye.wl.decadent.org.uk>
 <51345148.1040102@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51345148.1040102@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 08:46:16AM +0100, David Henningsson wrote:
> On 03/04/2013 06:13 AM, Ben Hutchings wrote:
> >On Mon, 2013-03-04 at 03:38 +0000, Ben Hutchings wrote:
> >>3.2-stable review patch.  If anyone has any objections, please let me know.
> >>
> >>------------------
> >>
> >>From: David Henningsson <david.henningsson@canonical.com>
> >>
> >>commit 30efd8debd1ef30be342d374f01e993509f5b76b upstream.
> >>
> >>Just as for analog codecs, a jack that isn't suitable for detection
> >>(in this case, NO_PRESENCE was set) should be a phantom Jack
> >>instead of a normal one.
> >>
> >>Thanks to Raymond Yau for spotting.
> >>
> >>BugLink: https://bugs.launchpad.net/bugs/961286
> >>BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=903869
> >>Signed-off-by: David Henningsson <david.henningsson@canonical.com>
> >>Signed-off-by: Takashi Iwai <tiwai@suse.de>
> >>[bwh: Backported to 3.2: adjust context]
> >>Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >
> >David, do I need to change this further for 3.2.y?
> 
> Greg and Ben,
> 
> Given some thought, the definition of is_jack_detectable has
> changed/improved over kernels. Therefore I think it's safer not to
> apply the patch at all for kernels earlier than 3.6. Let's revisit
> this decision if there's actually a user demand for this fix.

So should I revert this in the next 3.4 release, as it's now in the
3.4.35 release.

thanks,

greg k-h
