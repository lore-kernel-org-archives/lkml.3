Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaGaRaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:30:11 -0400
Received: from host171.canaca.com ([67.55.55.225]:42028 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaGaRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:30:03 -0400
Message-ID: <f86b6b4fbf48ce4cbeb9b537794a4eb8.squirrel@mungewell.org>
In-Reply-To: <3335238.KGDcEM6DjH@sigyn>
References: <3335238.KGDcEM6DjH@sigyn>
Date: Thu, 31 Jul 2014 13:29:57 -0400
Subject: Re: PATCH hid: Implement mode switching on Logitech gaming wheels
 accordingly to the documentation
From: simon@mungewell.org
To: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>
Cc: "Jiri Kosina" <jkosina@suse.cz>,
        "linux-input" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edwin@velds.nl, "elias.vds@gmail.com" <elias.vds@gmail.com>,
        "simon@mungewell.org" <simon@mungewell.org>,
        "Roland Bosa" <rbosa@logitech.com>
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


> +#define LG4FF_MSW_MIN 0
> +#define LG4FF_MSW_NATIVE 0	/* Switch device to its native mode (if
> applicable) */
> +#define LG4FF_MSW_DONTSWITCH 1	/* Leave device in its current mode */
> +#define LG4FF_MSW_DFP 2		/* Switch device so that it emulates Driving
> Force Pro (only G25, G27, DFGT) */
> +#define LG4FF_MSW_G25 3		/* Switch device so that it emulates G25 (only
> G27) */
> +#define LG4FF_MSW_MAX 3

Just to let everyone know I am looking at this patch, and have emailed
Michal some questions on whether it covers all options for control.

Cheers,
Simon.

