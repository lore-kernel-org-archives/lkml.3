Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaKEIMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:12:13 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:60492 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaKEIMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:12:09 -0500
Message-ID: <1415175123.2589.10.camel@sipsolutions.net>
Subject: Re: [PATCH v1 10/11] backports: prefix c-file / h-file auto
 backport with BPAUTO
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Date: Wed, 05 Nov 2014 09:12:03 +0100
In-Reply-To: <20141105080252.GK12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415090582-14129-11-git-send-email-mcgrof@do-not-panic.com>
	 <1415096092.2064.13.camel@sipsolutions.net>
	 <20141104215002.GF12953@wotan.suse.de>
	 <1415137850.2064.23.camel@sipsolutions.net>
	 <20141105002147.GJ12953@wotan.suse.de>
	 <1415172590.2589.1.camel@sipsolutions.net>
	 <20141105080252.GK12953@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 09:02 +0100, Luis R. Rodriguez wrote:

> > But the *code* changes
> > you're making here that check whether bp_prefix is being duplicated
> > aren't necessary for that, and are in fact confusing and dangerous.
> 
> Understood, thanks for the review, hopefully this is addressed with the
> latest series.

Actually, maybe you wanted these changes because you didn't want to end
up with CONFIG_BACKPORT_BPAUTO_ for integration? I think that's a small
price to pay though for code complexity trade-off, IMHO you should
accept CONFIG_BACKPORT_BPAUTO_ and remove the code changes.

johannes

