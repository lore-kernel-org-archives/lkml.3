Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaKZF0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:26:19 -0500
Received: from ozlabs.org ([103.22.144.67]:38699 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaKZF0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:26:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 1/2] virito: introduce methods of fixing device features
In-Reply-To: <1415857974-23326-1-git-send-email-jasowang@redhat.com>
References: <1415857974-23326-1-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 24 Nov 2014 11:38:13 +1030
Message-ID: <87sih9xv5u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> Buggy host may advertised buggy host features (a usual case is that host
> advertise a feature whose dependencies were missed). In this case, driver
> should detect and disable the buggy features by itself.

Sorry, I've been focussing elsewhere.

I would really prefer that drivers offer a "feature_depends" table,
which can indicate that feature A depends on feature B, and have the
core iterate, complain and fixup as necessary.

Is that expressive enough, or do we need more?

Thanks,
Rusty.
