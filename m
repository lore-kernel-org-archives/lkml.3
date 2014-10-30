Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161500AbaJaAj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:39:29 -0400
Received: from ozlabs.org ([103.22.144.67]:49694 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161292AbaJaAj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:39:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Cornelia Huck <cornelia.huck@de.ibm.com>, Paul Bolle <pebolle@tiscali.nl>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: Fix comment typo 'CONFIG_S_FAILED'
In-Reply-To: <20141020122858.60091942.cornelia.huck@de.ibm.com>
References: <1413796676.16435.9.camel@x220> <20141020122858.60091942.cornelia.huck@de.ibm.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 31 Oct 2014 10:29:25 +1030
Message-ID: <87vbn185ya.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:
> On Mon, 20 Oct 2014 11:17:56 +0200
> Paul Bolle <pebolle@tiscali.nl> wrote:
>
>> Without the VIRTIO_ prefix CONFIG_S_FAILED looks like a Kconfig macro.
>> So use that prefix here too.
>> 
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> Introduced in commit c6716bae52f9 ("virtio-pci: move freeze/restore to
>> virtio core").
>> 
>> Tested with "git grep" only.
>> 
>>  include/linux/virtio.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Applied.

Thanks!
Rusty.
