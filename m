Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaHLOC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:02:58 -0400
Received: from devoid-pointer.net ([31.31.77.140]:50824 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHLOC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:02:57 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "simon@mungewell.org" <simon@mungewell.org>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edwin@velds.nl, "elias.vds@gmail.com" <elias.vds@gmail.com>,
        Roland Bosa <rbosa@logitech.com>
Subject: Re: PATCH hid: Implement mode switching on Logitech gaming wheels accordingly to the documentation
Date: Tue, 12 Aug 2014 16:02:53 +0200
Message-ID: <4338127.9nsJWYLUyM@sigyn>
User-Agent: KMail/4.13.3 (Linux/3.15.0-1-my-rd; KDE/4.13.3; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1408121509550.15220@pobox.suse.cz>
References: <3335238.KGDcEM6DjH@sigyn> <f86b6b4fbf48ce4cbeb9b537794a4eb8.squirrel@mungewell.org> <alpine.LNX.2.00.1408121509550.15220@pobox.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 of August 2014 15:10:12 Jiri Kosina wrote:
> On Thu, 31 Jul 2014, simon@mungewell.org wrote:
> > > +#define LG4FF_MSW_MIN 0
> > > +#define LG4FF_MSW_NATIVE 0	/* Switch device to its native mode (if
> > > applicable) */
> > > +#define LG4FF_MSW_DONTSWITCH 1	/* Leave device in its current mode */
> > > +#define LG4FF_MSW_DFP 2		/* Switch device so that it emulates 
Driving
> > > Force Pro (only G25, G27, DFGT) */
> > > +#define LG4FF_MSW_G25 3		/* Switch device so that it emulates G25 
(only
> > > G27) */
> > > +#define LG4FF_MSW_MAX 3
> > 
> > Just to let everyone know I am looking at this patch, and have emailed
> > Michal some questions on whether it covers all options for control.
> 
> Hi guys,
> 
> did you reach any kind of conclusion here?

Hi,

Simon mailed me his revised patchset which has the changes broken out into 
four separate patches and allows to switch "extended compatibility" modes on 
the fly through sysfs. I looked them over and I they seem fine to me. I 
suppose he'll submit them for review very soon.

Michal
