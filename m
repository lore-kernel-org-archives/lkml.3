Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaI1XCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 19:02:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23496 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaI1XCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 19:02:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+5tLNIKBfYnyTmp26vsKLJ9DFSPPXcAZ0=
X-DKIM: OpenDKIM Filter v2.0.1 titan AF1A55EF966
Date: Sun, 28 Sep 2014 19:02:16 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eric Rost <eric.rost@mybabylon.net>, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: Fixed Conditional white space problems
Message-ID: <20140928230216.GF23926@titan.lakedaemon.net>
References: <20140928220828.GA12566@localhost>
 <20140928221445.GA25174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928221445.GA25174@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 06:14:45PM -0400, Greg KH wrote:
> How about working on getting rid of the #if crap in this driver, that
> will fix up this { } mess automatically.

Yes, I commented on that earlier, it's a rather big job and may not be
appropriate for a beginner.

Eric, if you'd like to tackle it, be aware that it's most likely going
to be a series of changes, and I'll be looking to see that no object
code has changed (./scripts/objdiff) across your patch series.

thx,

Jason.
