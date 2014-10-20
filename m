Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaJTK3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:29:12 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:56027 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaJTK3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:29:08 -0400
Date: Mon, 20 Oct 2014 12:28:58 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: Fix comment typo 'CONFIG_S_FAILED'
Message-ID: <20141020122858.60091942.cornelia.huck@de.ibm.com>
In-Reply-To: <1413796676.16435.9.camel@x220>
References: <1413796676.16435.9.camel@x220>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102010-0021-0000-0000-00000174600F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 11:17:56 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> Without the VIRTIO_ prefix CONFIG_S_FAILED looks like a Kconfig macro.
> So use that prefix here too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Introduced in commit c6716bae52f9 ("virtio-pci: move freeze/restore to
> virtio core").
> 
> Tested with "git grep" only.
> 
>  include/linux/virtio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

