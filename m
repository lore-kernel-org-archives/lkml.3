Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3EPQtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:49:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21959 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3EPQtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:49:33 -0400
MIME-Version: 1.0
Message-ID: <b12c2e22-f41c-490d-9d74-c85aa397e017@default>
Date: Thu, 16 May 2013 09:45:43 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Jonathan Corbet <corbet@lwn.net>
Subject: RE: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default>
 <20130514163541.GC4024@medulla>
 <f0272a06-141a-4d33-9976-ee99467f3aa2@default> <519408D6.10903@redhat.com>
In-Reply-To: <519408D6.10903@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rik van Riel [mailto:riel@redhat.com]
> Sent: Wednesday, May 15, 2013 4:15 PM
> To: Dan Magenheimer
> Cc: Seth Jennings; Andrew Morton; Greg Kroah-Hartman; Nitin Gupta; Minchan Kim; Konrad Wilk; Robert
> Jennings; Jenifer Hopper; Mel Gorman; Johannes Weiner; Larry Woodman; Benjamin Herrenschmidt; Dave
> Hansen; Joe Perches; Joonsoo Kim; Cody P Schafer; Hugh Dickens; Paul Mackerras; linux-mm@kvack.org;
> linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> 
> On 05/14/2013 04:18 PM, Dan Magenheimer wrote:
> 
> > It's unfortunate that my proposed topic for LSFMM was pre-empted
> > by the zsmalloc vs zbud discussion and zswap vs zcache, because
> > I think the real challenge of zswap (or zcache) and the value to
> > distros and end users requires us to get this right BEFORE users
> > start filing bugs about performance weirdness.  After which most
> > users and distros will simply default to 0% (i.e. turn zswap off)
> > because zswap unpredictably sometimes sucks.
> 
> I'm not sure we can get it right before people actually start
> using it for real world setups, instead of just running benchmarks
> on it.
> 
> The sooner we get the code out there, where users can play with
> it (even if it is disabled by default and needs a sysfs or
> sysctl config option to enable it), the sooner we will know how
> well it works, and what needs to be changed.

/me sets stage of first Star Wars (1977)

/me envisions self as Obi-Wan Kenobi, old and tired of fighting,
in lightsaber battle with protege Darth Vader / Anakin Skywalker

/me sadly turns off lightsaber, holds useless handle at waist,
takes a deep breath, and promptly gets sliced into oblivion.

Time for A New Hope(tm).

(/me cc's Jon Corbet for a longshot last chance of making LWN's
Kernel Development Quotes of the Week.)
