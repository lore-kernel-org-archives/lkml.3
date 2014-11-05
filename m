Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaKEH5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:57:31 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:60198 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaKEH51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:57:27 -0500
Message-ID: <1415174245.2589.9.camel@sipsolutions.net>
Subject: Re: [PATCH v2 09/13] backports: define C code backport version info
 using CPTCFG_
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 05 Nov 2014 08:57:25 +0100
In-Reply-To: <1415157517-15442-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20141105_042101_003207_6471AD18)
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415157517-15442-10-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141105_042101_003207_6471AD18)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> In order to help unify the naming scheme for shared
> backports versioning information rely on the CPTCFG_
> prefix, when integration support gets added that will
> translate to the respective CONFIG_BACKPORT_ prefix.
> Kconfig opt env entries don't get propagated out, so
> we need to define these ourselves. This leaves all
> other names in place for packaging and just focuses
> on sharing on the C / header code.

What difference does this make? It'll break some scripting that we have
for sure (assuming the BACKPORTED_ prefix), so naturally I'd like to see
why it is necessary.

johannes

