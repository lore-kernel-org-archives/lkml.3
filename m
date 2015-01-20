Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbbATGkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:40:33 -0500
Received: from ozlabs.org ([103.22.144.67]:44923 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbbATGka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:40:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/6] virtio: graceful failure with get == NULL
In-Reply-To: <20150113194909.GO21393@redhat.com>
References: <1421160167-18498-1-git-send-email-mst@redhat.com> <20150113194909.GO21393@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Jan 2015 16:59:15 +1030
Message-ID: <87oapuart0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, Jan 13, 2015 at 04:43:07PM +0200, Michael S. Tsirkin wrote:
>> virtio 1.0 says device configuration is optional, but most drivers treat it as
>> mandatory.  Even if presented by device, guest bios might disable the BAR
>> holding that configuration, so we can't assume it's there, but we also don't
>> want to fail if not in case drivers can cope with it's absence - such as caif
>> or rng.
>> 
>> Add code to drivers to check presence of get callback and fail gracefully.
>
> Rusty, in case it's not clear: I'd like to hear
> your opinion on these patches, since virtio pci modern
> driver I'm now preparing for submission, depends on this.

Just to note for anyone following, that these are now in my virtio-next
tree.

Cheers,
Rusty.
