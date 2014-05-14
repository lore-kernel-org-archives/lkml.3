Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaENR6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:58:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48537 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaENR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:58:30 -0400
Date: Wed, 14 May 2014 10:58:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: simon@mungewell.org
Cc: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
Message-ID: <20140514175825.GA30089@core.coreip.homeip.net>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
 <1398524543-15012-2-git-send-email-madcatxster@devoid-pointer.net>
 <20140514063806.GC13621@core.coreip.homeip.net>
 <1818063.tFLKhAd1oy@sigyn>
 <ceda9d065796952132cc6ff971c0537b.squirrel@mungewell.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceda9d065796952132cc6ff971c0537b.squirrel@mungewell.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:11:40AM -0400, simon@mungewell.org wrote:
> 
> > If we ever come across a really memoryless device it should not be
> > particularly difficult to add another callback to ff-memless-next which
> > would emulate conditional effects with constant force.
> 
> It should be noted that some (/many?) applications/games already use the
> CF with position feedback to emulate behaviour such as springs. The feed
> back loop is simply not fast enough to do emulation of friction/inertia.
> 
> I don't believe that the FF layer in the kernel should be 'tricked out'
> with lots of emulation features.
> 
> As a game designer (ok... tinkerer) it's a bit of a pain that devices lie
> about what they can really do - ie. gamepads claiming periodic ability
> when all they are doing is faking it with rumble.

Would it help if kernel would indicate which effects are native and
which are emulated?

Thanks.

-- 
Dmitry
