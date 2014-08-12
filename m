Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaHLNKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:10:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaHLNKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:10:15 -0400
Date: Tue, 12 Aug 2014 15:10:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "simon@mungewell.org" <simon@mungewell.org>
cc: =?ISO-8859-15?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edwin@velds.nl, "elias.vds@gmail.com" <elias.vds@gmail.com>,
        Roland Bosa <rbosa@logitech.com>
Subject: Re: PATCH hid: Implement mode switching on Logitech gaming wheels
 accordingly to the documentation
In-Reply-To: <f86b6b4fbf48ce4cbeb9b537794a4eb8.squirrel@mungewell.org>
Message-ID: <alpine.LNX.2.00.1408121509550.15220@pobox.suse.cz>
References: <3335238.KGDcEM6DjH@sigyn> <f86b6b4fbf48ce4cbeb9b537794a4eb8.squirrel@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, simon@mungewell.org wrote:

> > +#define LG4FF_MSW_MIN 0
> > +#define LG4FF_MSW_NATIVE 0	/* Switch device to its native mode (if
> > applicable) */
> > +#define LG4FF_MSW_DONTSWITCH 1	/* Leave device in its current mode */
> > +#define LG4FF_MSW_DFP 2		/* Switch device so that it emulates Driving
> > Force Pro (only G25, G27, DFGT) */
> > +#define LG4FF_MSW_G25 3		/* Switch device so that it emulates G25 (only
> > G27) */
> > +#define LG4FF_MSW_MAX 3
> 
> Just to let everyone know I am looking at this patch, and have emailed
> Michal some questions on whether it covers all options for control.

Hi guys,

did you reach any kind of conclusion here?

-- 
Jiri Kosina
SUSE Labs
