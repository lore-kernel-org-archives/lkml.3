Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaKEVTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:19:20 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:38028 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaKEVTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:19:18 -0500
Message-ID: <1415222354.7485.12.camel@sipsolutions.net>
Subject: Re: [PATCH v2 05/13] backports: use BACKPORT_DIR prefix on kconfig
 sources
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Date: Wed, 05 Nov 2014 22:19:14 +0100
In-Reply-To: <20141105201105.GO12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415157517-15442-6-git-send-email-mcgrof@do-not-panic.com>
	 <1415173905.2589.5.camel@sipsolutions.net>
	 <20141105201105.GO12953@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 21:11 +0100, Luis R. Rodriguez wrote:

> This does mean that bp_prefix topic *can* also be tied down
> with this other directory prefix as a form of 'builder' for
> integration. Making the prefix configurable would make sense
> then only if also making the directory prefix should be
> configurable.

Indeed.

> I think we're better off right now with just supporting two
> approaches with their own directory prefix, and prefixes
> for variables.

Sure, that's fine. I have no issues with either, but I'd like to see the
two cases actually combined and separated, in the sense that you don't
have magic code that tries both and just succeeds on one, but only have
code that tries the right thing.

johannes

