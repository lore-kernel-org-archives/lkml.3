Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaJBVOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:14:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41621 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaJBVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:14:01 -0400
Date: Thu, 2 Oct 2014 23:13:59 +0200
From: Pavel Machek <pavel@denx.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: sre@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSI: remove deprecated IRQF_DISABLED
Message-ID: <20141002211359.GA21093@amd>
References: <1412195335-9437-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20140912143722.GA22420@xo-6d-61-c0.localdomain>
 <542DB350.3080707@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542DB350.3080707@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-10-02 22:19:28, Michael Opdenacker wrote:
> On 09/12/2014 04:40 PM, Pavel Machek wrote:
> > On Wed 2014-10-01 22:28:55, Michael Opdenacker wrote:
> >> Remove the use of the IRQF_DISABLED flag
> >> from drivers/hsi/clients/nokia-modem.c
> >>
> >> It's a NOOP since 2.6.35 and it will be removed soon.
> >>
> >> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> Thanks! Wow, you have a nice system date, writing from the past (Sep. 12).

My TARDIS is better and better. Normally, I write from 1970 :-).

Why do all the great machines lack working RTC? Spitz, n900,
OLPC-1.75...

								Pavel

#!/bin/bash
F=/etc/zaurus.time
if [ $(date +%s) -lt $(< $F) ];
    then
    date -s @$(< $F)
    fi
date +%s > $F

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
