Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaHNQaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:30:10 -0400
Received: from host171.canaca.com ([67.55.55.225]:40004 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaHNQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:30:08 -0400
Message-ID: <629e44bcbdb7061b2f004cf9125fed9b.squirrel@mungewell.org>
In-Reply-To: <4338127.9nsJWYLUyM@sigyn>
References: <3335238.KGDcEM6DjH@sigyn>
    <f86b6b4fbf48ce4cbeb9b537794a4eb8.squirrel@mungewell.org>
    <alpine.LNX.2.00.1408121509550.15220@pobox.suse.cz>
    <4338127.9nsJWYLUyM@sigyn>
Date: Thu, 14 Aug 2014 12:30:02 -0400
Subject: Re: PATCH hid: Implement mode switching on Logitech gaming wheels
 accordingly to the documentation
From: simon@mungewell.org
To: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>
Cc: "Jiri Kosina" <jkosina@suse.cz>,
        "simon@mungewell.org" <simon@mungewell.org>,
        "linux-input" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edwin@velds.nl, "elias.vds@gmail.com" <elias.vds@gmail.com>,
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


> Simon mailed me his revised patchset which has the changes broken out into
> four separate patches and allows to switch "extended compatibility" modes
> on
> the fly through sysfs. I looked them over and I they seem fine to me. I
> suppose he'll submit them for review very soon.

Whilst it is my intention to submit them, I might not achieve the 'very
soon' part.... earliest I think would be mid next week as they still need
a little tweaking.
Simon

