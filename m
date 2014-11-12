Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaKLSuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:50:54 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:26729 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100AbaKLSux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:50:53 -0500
Date: Wed, 12 Nov 2014 12:50:37 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: Petr Mladek <pmladek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] virtio_balloon: Convert "vballon" kthread into a
 workqueue
Message-ID: <20141112185037.GB53560@unpythonic.net>
References: <1415797368-22660-1-git-send-email-pmladek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415797368-22660-1-git-send-email-pmladek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial typo "vballon" should be "vballoon" in subject (and in changelog,
leak_ballon should be leak_balloon)

Jeff
