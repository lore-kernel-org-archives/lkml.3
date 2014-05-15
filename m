Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaEOUKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:10:49 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36247 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaEOUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:10:48 -0400
Date: Thu, 15 May 2014 22:10:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/9] perf, tools: Add perf download to download event
 files v2
Message-ID: <20140515201045.GD1873@two.firstfloor.org>
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
 <1399935074-25167-6-git-send-email-andi@firstfloor.org>
 <87zjilkkfw.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjilkkfw.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you please extend this script to support curl also?  It seems the
> wget is not installed by default on my system.

I looked at it, but it's a major pain because curl is totally
incompatible. I don't think it's a major burden to install wget?

> > +set -e
> > +
> > +if [ "$1" == "" ] ; then
> > +	S=$(awk '
> > +/^vendor/     		{ V=$3 }
> > +/^model/ && $2 == ":" 	{ M=$3 }
> > +/^cpu family/ 		{ F = $4 }
> 
> Inconsistency in using whitespace..

awk scripts always start at column 0

-Andi
