Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaGIAfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:35:45 -0400
Received: from ozlabs.org ([103.22.144.67]:34459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbaGIAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:35:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC 1/2] virtio: support for urgent descriptors
In-Reply-To: <1404203661-7521-1-git-send-email-mst@redhat.com>
References: <1404203661-7521-1-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Jul 2014 09:58:43 +0930
Message-ID: <87y4w35q9w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Below should be useful for some experiments Jason is doing.
> I thought I'd send it out for early review/feedback.
>
> Compiled-only at this point.

It's not a terrible idea, but it will come down to how effective it is
in practice.

I'm tempted to make it v1.0 only though.

Cheers,
Rusty.
