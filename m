Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaENPLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:11:46 -0400
Received: from host171.canaca.com ([67.55.55.225]:56897 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaENPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:11:44 -0400
Message-ID: <ceda9d065796952132cc6ff971c0537b.squirrel@mungewell.org>
In-Reply-To: <1818063.tFLKhAd1oy@sigyn>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
    <1398524543-15012-2-git-send-email-madcatxster@devoid-pointer.net>
    <20140514063806.GC13621@core.coreip.homeip.net>
    <1818063.tFLKhAd1oy@sigyn>
Date: Wed, 14 May 2014 11:11:40 -0400
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: simon@mungewell.org
To: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If we ever come across a really memoryless device it should not be
> particularly difficult to add another callback to ff-memless-next which
> would emulate conditional effects with constant force.

It should be noted that some (/many?) applications/games already use the
CF with position feedback to emulate behaviour such as springs. The feed
back loop is simply not fast enough to do emulation of friction/inertia.

I don't believe that the FF layer in the kernel should be 'tricked out'
with lots of emulation features.

As a game designer (ok... tinkerer) it's a bit of a pain that devices lie
about what they can really do - ie. gamepads claiming periodic ability
when all they are doing is faking it with rumble.

Simon.



