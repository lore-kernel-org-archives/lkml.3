Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaLPXut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:50:49 -0500
Received: from ozlabs.org ([103.22.144.67]:37680 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbaLPXur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:50:47 -0500
Message-ID: <1418773844.6400.6.camel@ellerman.id.au>
Subject: Re: [PATCH 13/18] powerpc/uaccess: fix sparse errors
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Wed, 17 Dec 2014 10:50:44 +1100
In-Reply-To: <20141216164746.GB21876@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
	 <1418575877-21488-14-git-send-email-mst@redhat.com>
	 <20141216164746.GB21876@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 18:47 +0200, Michael S. Tsirkin wrote:
> On Sun, Dec 14, 2014 at 06:52:51PM +0200, Michael S. Tsirkin wrote:
> > virtio wants to read bitwise types from userspace using get_user.  At the
> > moment this triggers sparse errors, since the value is passed through an
> > integer.
> > 
> > Fix that up using __force.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Ping.

Ping? You only sent it two days ago. And you only responded to my questions
yesterday evening.

> Do powerpc maintainers consider fixing sparse errors
> applicable for 3.19?

Yeah, with your expanded explanation I'm fine with it.

> If yes, can you pls merge this patch?

Yes I will.

cheers


