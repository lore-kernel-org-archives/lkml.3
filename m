Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaJTXCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:02:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbaJTXCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:02:34 -0400
From: Paul Moore <pmoore@redhat.com>
To: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, aviro@redhat.com
Subject: Re: [PATCH V5 0/5] audit by executable name
Date: Mon, 20 Oct 2014 19:02:33 -0400
Message-ID: <2652562.S2IH3gqS0u@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1413845247.30946.49.camel@localhost>
References: <cover.1412303728.git.rgb@redhat.com> <2527124.XNMpLdSfeq@x2> <1413845247.30946.49.camel@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2014 06:47:27 PM Eric Paris wrote:
> On Mon, 2014-10-20 at 16:25 -0400, Steve Grubb wrote:
> > On Thursday, October 02, 2014 11:06:51 PM Richard Guy Briggs wrote:
> > > This is a part of Peter Moody, my and Eric Paris' work to implement
> > > audit by executable name.
> > 
> > Does this patch set define an AUDIT_VERSION_SOMETHING and then set
> > AUDIT_VERSION_LATEST to it? If not, I need one to tell if the kernel
> > supports it when issuing commands. Also, if its conceivable that kernels
> > may pick and choose what features could be backported to a curated
> > kernel, should AUDIT_VERSION_ be a number that is incremented or a bit
> > mask?
> 
> Right now the value is 2. So this is your last hope if you want to make
> it a bitmask. I'll leave that up to paul/richard to (over) design.

Audit is nothing if not over-designed.  I want to make sure we're consistent 
with the previous design methodologies ;)

I've been thinking about this for about the past half-hour while I've been 
going through some other mail and I'm not really enthused about using the 
version number to encode capabilities.  What sort of problems would we have if 
we introduced a new audit netlink command to query the kernel for audit 
capabilities?

-- 
paul moore
security and virtualization @ redhat

