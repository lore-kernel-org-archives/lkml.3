Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab3ENTRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:17:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3ENTRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:17:03 -0400
Message-ID: <51928D84.2040305@infradead.org>
Date: Tue, 14 May 2013 12:16:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: linux-next: Tree for May 14 (vhost_scsi)
References: <20130514141739.46eb9b42c95cb02947610379@canb.auug.org.au>
In-Reply-To: <20130514141739.46eb9b42c95cb02947610379@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/13 21:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130513:
> 
> <crickets :-)>


on x86_64:

ERROR: "memcpy_fromiovec" [drivers/vhost/vhost_scsi.ko] undefined!


It needs to depend on NET since net/core/ provides that function.


-- 
~Randy
