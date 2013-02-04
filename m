Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3BDKSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:18:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab3BDKSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:18:43 -0500
Date: Mon, 4 Feb 2013 11:18:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaroslav Skarvada <jskarvad@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 14/33] iwlegacy: fix IBSS cleanup
Message-ID: <20130204101826.GB2434@redhat.com>
References: <20130201104724.605715763@linuxfoundation.org>
 <20130201104725.670932664@linuxfoundation.org>
 <1359850847.31386.91.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359850847.31386.91.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 01:20:47AM +0100, Ben Hutchings wrote:
> On Fri, 2013-02-01 at 11:49 +0100, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Stanislaw Gruszka <sgruszka@redhat.com>
> > 
> > commit fa4cffcba9e13798ed7c6b8526b91b1631ecb53e upstream.
> > 
> > We do not correctly change interface type when switching from
> > IBSS mode to STA mode, that results in microcode errors.
> > 
> > Resolves:
> > https://bugzilla.redhat.com/show_bug.cgi?id=886946
> > 
> > Reported-by: Jaroslav Skarvada <jskarvad@redhat.com>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [...]
> 
> This one didn't apply to 3.2 or presumably to 3.0.  Do they have the bug
> and if so could you provide a backport?
They have the bug, but backport is not simple and require testing.
I prefer to not do it. We have workaround for the bug - reload
module after disconnecting from IBSS network.

Stanislaw

