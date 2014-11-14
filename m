Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935290AbaKNUrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:47:37 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:53570 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbaKNUrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:47:35 -0500
Message-ID: <1415998051.1847.2.camel@sipsolutions.net>
Subject: Re: [PATCH v3 10/21] backports: avoid git tree reinitialization
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 14 Nov 2014 21:47:31 +0100
In-Reply-To: <1415693712-23743-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20141111_091920_022089_D2F879DA)
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415693712-23743-11-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141111_091920_022089_D2F879DA)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 00:15 -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> When using backports against for packaging with --gitdebug you either
> have to use --clean or assume the directory is empty already. In either
> case you start fresh. With integration this will be a bit different, you
> could end up with a project directory where the git tree was present but
> only the target directory was empty.
> 
> Calling git init on an already existing git directory will reinitialize
> your git tree, that can reset some config stuff, let's avoid that.

I guess I don't care much, but it seems strange to me that you'd use
--gitdebug in this case, you'd end up committing crappy patches to the
top-level kernel tree?

johannes

