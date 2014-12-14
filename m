Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaLNUgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:36:09 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:42530 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaLNUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:35:55 -0500
Date: Sun, 14 Dec 2014 21:35:46 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 04/18] avr32/uaccess: fix sparse errors
Message-ID: <20141214203544.GA21391@samfundet.no>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
 <1418575877-21488-5-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418575877-21488-5-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 14 Dec 2014 18:52:14 +0200 or thereabout, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/uaccess.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

<snipp diff>

-- 
Hans-Christian Egtvedt
