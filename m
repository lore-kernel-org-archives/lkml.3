Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaEETjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:39:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:56985 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaEETjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:39:04 -0400
Date: Mon, 5 May 2014 21:38:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Streetman <ddstreet@ieee.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Weijie Yang <weijieut@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>
Subject: Re: [PATCH 4/4] swap: change swap_list_head to plist, add
 swap_avail_head
Message-ID: <20140505193857.GC11096@twins.programming.kicks-ass.net>
References: <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
 <1399057350-16300-1-git-send-email-ddstreet@ieee.org>
 <1399057350-16300-5-git-send-email-ddstreet@ieee.org>
 <20140505191341.GA18397@home.goodmis.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yiup30KVCQiHUZFC"
Content-Disposition: inline
In-Reply-To: <20140505191341.GA18397@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yiup30KVCQiHUZFC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2014 at 03:13:41PM -0400, Steven Rostedt wrote:
> On Fri, May 02, 2014 at 03:02:30PM -0400, Dan Streetman wrote:
> I know Peter Zijlstra was doing some work to convert the rtmutex code to use
> rb-trees instead of plists. Peter is that moving forward?

commit fb00aca474405f4fa8a8519c3179fed722eabd83
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Nov 7 14:43:43 2013 +0100

    rtmutex: Turn the plist into an rb-tree

That one you mean? Yeah it should be in:

# git describe --contains fb00aca474405f4fa8a8519c3179fed722eabd83 --match "v*"
v3.14-rc1~170^2~39



--yiup30KVCQiHUZFC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJTZ+jRAAoJEHZH4aRLwOS6C+QP92kSswaUXHZgrAXxCYYO9+3j
9U2I+Nkyg5oO7FJ/yK2dSa1jNyj/NSLGMTkoDfS+Tu55NWMg/ytdZFqU3UtcCpYS
MYpzO3Dz1f8hTXXeGZk3oeueuAqxJUHWbd2c0t90AWWVf2BGvdJkOp/g4rZKEDJq
zZ0SpWaqXr61gj/rEK47YxECP2RFx4T57wTQmQ1m0+SW1oAGyOimkgZGO238HaIE
HTJE0WeG3IKRIYTUlVkRI/sX/4Pd+ABRTNbStqPFcc9/CT0Guf8BvymNdgGLx4lP
D6IFiNzt3go+vurk0CgEai5MFUQSuiiNL8vNAuIkH8jI5dxkTtwUPD5dAQM/3KDr
WJtGgazaIVkNsHQEpyDls4NXheEmZCfRHf5WBhWt49JpkSitzVvtoI4aaRRnUHel
zGUnhDdY4NAQ3UH750oiUaNZdBHfxsNippYMM56gGXQmucIEGPXbBLzvfLRjQHxR
B1/yMj9W88cAYwJoCtWfHQ1DHrpYriEg53gOk4bvrrbKPCXpWrVF0jHJ1aeaYBVr
gWCGyd5CVdxJm0yeOgUAbkkgDnrR5aYLV5Os0GsnoXYEiM62+NCBIfMYeVtAv+tC
nPRAzf/83b2PUi+Bti2U/aLhJRgKhfjnNHkyM1HBuN9KBf5RZ4w6jCJqtyURYSwc
09Cv3ThnogvbOd7jjyI=
=zS1Q
-----END PGP SIGNATURE-----

--yiup30KVCQiHUZFC--
