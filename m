Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaBXJyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:54:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaBXJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:54:17 -0500
Date: Mon, 24 Feb 2014 09:54:10 +0000
From: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Ray Strode <halfline@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>, Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.11 085/121] tty: Set correct tty name in 'active' sysfs
 attribute
Message-ID: <20140224095410.GA4043@hercules>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
 <1392986945-9693-86-git-send-email-luis.henriques@canonical.com>
 <CAA_Uwz+DZJ0f6ow3YSsSK9HDt639P7Up4_5ienoJO5VW4ZhF2Q@mail.gmail.com>
 <CA+5PVA72=8KvdOgTLc7NZfMq_bFob6-rEhTktNJJ0qBRgr4iiQ@mail.gmail.com>
 <CANq1E4Q4h5rF1MY+hp5DS9M7Jo43Op_gRZgBJtiTHswX0EAEDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4Q4h5rF1MY+hp5DS9M7Jo43Op_gRZgBJtiTHswX0EAEDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 09:09:22PM +0100, David Herrmann wrote:
> Hi
> 
> On Fri, Feb 21, 2014 at 3:46 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > On Fri, Feb 21, 2014 at 9:37 AM, Ray Strode <halfline@gmail.com> wrote:
> >> Hi,
> >>
> >> This broke plymouth, i think.  Plymouth used the herustic:
> >> "/sys/class/tty/console/active contains something other than tty0" to
> >> mean "probably has serial consoles, force verbose messages instead of
> >> a splash screen".  Now on a normal system it contains tty1.
> >>
> >> I pushed a commit to plymouth that gets it working again, but it could
> >> cause compatiblity concerns if new kernels are pushed to old releases.
> >
> > Hm.  Breaking userspace is probably a bad thing here.
> >
> > Greg, you have this queued for 3.13.5 at the moment.  Maybe we should
> > hold off on this one until this discussion is sorted out?
> 
> Looks like a broken patch, not a broken idea. So you should probably
> hold off on this one till we figure it out. See Kay's comment on
> Greg's series for more.
> 
> Thanks
> David

I'll just drop this patch from the 3.11 kernel.  Thank you all!

Cheers,
--
Luís
