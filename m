Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaJVOKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:10:03 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49859 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaJVOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:10:00 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:bd21:7cf6:92dd:9d5c]
In-Reply-To: <20141022080302.GA4037@localhost.localdomain>
References: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com>
 <20141021110724.GA16479@netboy> <20141021.123544.9516812519754063.davem@davemloft.net>
 <544690CB.4030307@gmail.com> <20141021182757.GA3960@localhost.localdomain>
 <CAOFdcFNYHgupvMChb4NedMsUMAOmE8k0D_F5eRjL-8H8ft=eRw@mail.gmail.com> <20141022080302.GA4037@localhost.localdomain>
From: Peter Foley <pefoley2@pefoley.com>
Date: Wed, 22 Oct 2014 10:09:37 -0400
Message-ID: <CAOFdcFO=aLHKtogCf3Sz+XFFcm56JSTi=Om7S+XLdr71YCnFaw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: ptp: Fix build failure on MIPS cross builds
To: Richard Cochran <richardcochran@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, David Miller <davem@davemloft.net>,
        markos.chandras@imgtec.com, linux-mips@linux-mips.org, corbet@lwn.net,
        netdev@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 4:03 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> In the mean time, I would like to restore the testptp.mk that *does*
> cross compile, so that people may use the test program if they
> want. In fact I use this all the time, and so I am a bit annoyed that
> something working was deleted and replaced with something broken.

Sure, I didn't realize that anyone was actually using testptp.mk on a
regular basis.
Feel free to restore it.
