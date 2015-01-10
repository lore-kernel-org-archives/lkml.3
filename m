Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbbAJDMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 22:12:46 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56035 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbbAJDMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 22:12:44 -0500
From: Paul Moore <paul@paul-moore.com>
To: Dominick Grift <dac.override@gmail.com>, Paul Moore <pmoore@redhat.com>
CC: Dave Jones <davej@codemonkey.org.uk>, Stephen Smalley <sds@epoch.ncsc.mil>,
        James Morris <james.l.morris@oracle.com>,
        selinux <selinux@tycho.nsa.gov>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 09 Jan 2015 22:12:39 -0500
Message-ID: <14ad1d43100.2806.85c95baa4474aabc7814e68940a78392@paul-moore.com>
In-Reply-To: <1420837263.31986.0.camel@gmail.com>
References: <20150108190822.GB4365@codemonkey.org.uk>
 <CAB9W1A2nTN2DJ699BXL_r_aXCk-O9-KrTLSi731isQWpPUmkwg@mail.gmail.com>
 <20150109191329.GA19400@codemonkey.org.uk>
 <6645675.NppomaThWx@sifl>
 <1420837263.31986.0.camel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0 AquaMail/1.5.1.12 (build: 21020012)
Subject: Re: noisy selinux messages on tmpfs mount.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

systemd has taken over cron too?  I suppose that is a logical extension, 
but still...

--
paul moore
www.paul-moore.com



On January 9, 2015 4:01:29 PM Dominick Grift <dac.override@gmail.com> wrote:

> On Fri, 2015-01-09 at 15:55 -0500, Paul Moore wrote:
> > On Friday, January 09, 2015 02:13:29 PM Dave Jones wrote:
> > > On Fri, Jan 09, 2015 at 08:06:49AM -0500, Stephen Smalley wrote:
> > >  > We already reduced that message to KERN_DEBUG.  Is that not sufficient?
> > >
> > > That doesn't really help with the flooding of dmesg, so no.
> > > I should also note that it's not just logging in that creates a new
> > > session, it also seems to be getting triggered by cron jobs, or
> > > whatever the systemd replacement is.
> >
> > I wonder if this is cron/systemd/whatever creating a new namespace and
> > mounting a new tmpfs in the namespace?  If yes, I wonder if we could 
> limit the
> > messages to the initial namespace ... ?
> >
>
> It is systemd logind creating sessions (e.g. creating /run/user/$UID and
> mounting a tmpfs on it)
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


