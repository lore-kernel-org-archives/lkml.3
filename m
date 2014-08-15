Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaHONPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:15:48 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46581 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaHONPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:15:47 -0400
Date: Fri, 15 Aug 2014 08:15:37 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, seth.forshee@canonical.com
Subject: Re: [PATCH 3/3] fuse: Allow mounts from user namespaces
Message-ID: <20140815131537.GA68427@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	lxc-devel@lists.linuxcontainers.org,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Michael H. Warfield" <mhw@wittsend.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
 <1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
 <CAJfpegvMeiZG09U3aXvxKV+GPSn6zFgLbUwXGpTuoVSbnvgfmw@mail.gmail.com>
 <20140721124725.GB111224@ubuntu-hedt>
 <CAJfpegs=V5BpNdgn1JSLsvUsAnmhPvGJZobF1y_NAysb==Z1-A@mail.gmail.com>
 <20140721143442.GD111224@ubuntu-hedt>
 <87r41er3n6.fsf@x220.int.ebiederm.org>
 <20140722033044.GE111224@ubuntu-hedt>
 <20140725194619.GC28875@ubuntu-hedt>
 <CAJfpegsY0dRD2=AcKYbP7AsWHqxnj++jMxsYrCcCWbS9RzfB7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsY0dRD2=AcKYbP7AsWHqxnj++jMxsYrCcCWbS9RzfB7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 06:27:36PM +0200, Miklos Szeredi wrote:
> On Fri, Jul 25, 2014 at 9:46 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> 
> >
> > I'd appreciate it if you could take a look at these branches and let me
> > know which way you want to go so I'll know where to focus my time.
> 
> I'll be offline for the following week, and will have a look after that.

Ping. It's been a couple of weeks now, so I'm wondering if this might
have fallen off your radar.

Thanks,
Seth
