Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaFSRQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:16:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaFSRQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:16:00 -0400
Message-ID: <53A31ACF.5020302@infradead.org>
Date: Thu, 19 Jun 2014 10:15:59 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: linux-next: Tree for Jun 19 (vhost_scsi)
References: <20140619161632.58b442e4@canb.auug.org.au>
In-Reply-To: <20140619161632.58b442e4@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/14 23:16, Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc allyesconfig is again broken more than usual.
> 
> Changes since 20140618:
> 

on x86_64:
CONFIG_NET is not enabled.

ERROR: "memcpy_fromiovecend" [drivers/vhost/vhost_scsi.ko] undefined!

drivers/vhost/scsi.c calls memcpy_fromiovecend().
This function is not available when CONFIG_NET is not enabled.


-- 
~Randy
