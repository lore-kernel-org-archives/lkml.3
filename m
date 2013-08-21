Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3HUPyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:54:22 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49977 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751618Ab3HUPyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:54:20 -0400
Date: Wed, 21 Aug 2013 10:54:16 -0500
From: Ben Myers <bpm@sgi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: cbe-oss-dev@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dwight Engen <dwight.engen@oracle.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-next@vger.kernel.org,
        Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20130821155416.GH5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
 <20130820120702.000b044e@oracle.com>
 <20130820192844.GC5262@sgi.com>
 <20130821102246.4e3c4c8fe549d8c7760da96d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821102246.4e3c4c8fe549d8c7760da96d@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen,

On Wed, Aug 21, 2013 at 10:22:46AM +1000, Stephen Rothwell wrote:
> On Tue, 20 Aug 2013 14:28:44 -0500 Ben Myers <bpm@sgi.com> wrote:
> > I'd prefer not to break Stephen's tree two days in a row.  We could just revert
> > d6970d4b726c in the xfs tree for the time being as Stephen has done, but given
> > the choice would prefer the fix.  Do you have a preference between the two
> > approaches that Dwight has posted?  The first seems more conservative...
> 
> I will automatically revert that commit when I merge the xfs tree until
> some other solution is forthcoming (so you don't have to do the revert in
> the xfs tree).

Gah.  That makes sense.  ;)

> This does need to be fixed fairly soon, though.

Agreed, thanks.

-Ben
