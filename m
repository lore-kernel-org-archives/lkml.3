Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3IZVdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:33:24 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:43402 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753875Ab3IZVdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:33:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714
X-HE-Tag: wish42_1cb608d6ce41a
X-Filterd-Recvd-Size: 1951
Message-ID: <1380231195.17366.82.camel@joe-AO722>
Subject: Re: [PATCH RESEND v3 0/7] Enable Drivers for Intel MIC X100
 Coprocessors.
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Date: Thu, 26 Sep 2013 14:33:15 -0700
In-Reply-To: <20130926205424.GB19455@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
	 <1378431368.19204.3.camel@joe-AO722> <20130926205424.GB19455@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 13:54 -0700, Greg Kroah-Hartman wrote:
> On Thu, Sep 05, 2013 at 06:36:08PM -0700, Joe Perches wrote:
> > Whitespace neatening...
> > 
> > Multiline statement argument alignment.
> > Argument wrapping.
> > Use kmalloc_array instead of kmalloc.
> > 
> > ---
> 
> -ENOSIGNEDOFFBY :(

These were just suggestions for Sudeep.

Sudeep said he'd incorporate and resend the series.

Sudeep?  Were you ever going to do that?

