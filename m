Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbbAUXeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:34:19 -0500
Received: from ozlabs.org ([103.22.144.67]:48728 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbAUXeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:34:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: kraxel@redhat.com
Subject: Re: [PATCH 00/05] virtio_pci modern driver fixups
In-Reply-To: <1421771093-1589-1-git-send-email-mst@redhat.com>
References: <1421771093-1589-1-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 21 Jan 2015 16:30:05 +1030
Message-ID: <874mrkbrmi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> These are fixup patches for virtio pci modern.
> I think it's best to simply squash them in the
> appropriate original patches - rebase -i and then apply,
> then rebase -i --autosquash to do this automatically.

I do not like rebasing virtio-next.  However, as I've already
done it once today, I've rebased again.

These kind of issues have made it more urgent that I get virtio-1.0-pci
working with lguest, to see if we are at least bug-compatible.

Thanks,
Rusty.
