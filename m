Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbaIQUXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbaIQUXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:23:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANP1eJEJG-f1i=4tntOxfdz1wy5RCUVm=M-1oB5k=k8uyADVYg@mail.gmail.com>
References: <CANP1eJEJG-f1i=4tntOxfdz1wy5RCUVm=M-1oB5k=k8uyADVYg@mail.gmail.com> <cover.1407948737.git.milosz@adfin.com> <53EB992D.6040608@adfin.com> <32705.1409149899@warthog.procyon.org.uk> <CANP1eJFOw+2etaocge_h4tj7wigjNpcD0KsNW41pWaXFdToyDQ@mail.gmail.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32200.1410985387.1@warthog.procyon.org.uk>
Date: Wed, 17 Sep 2014 21:23:07 +0100
Message-ID: <32201.1410985387@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> David, I know you're busy with other things. Would you like me to
> re-spin the cleaned patches for you as a pull requests so you try to
> get this upstream. I really want to see those fixes make it into
> upstream.

I've sent them Linuswards.

David
