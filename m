Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3BXS3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 13:29:24 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51556 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab3BXS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 13:29:21 -0500
Date: Sun, 24 Feb 2013 10:29:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Randy Dunlap <rdunlap@infradead.org>, James Morris <jmorris@namei.org>,
        axboe <axboe@kernel.dk>, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix part_pack_uuid() build error
In-Reply-To: <1361718944.2908.49.camel@falcor1.watson.ibm.com>
Message-ID: <alpine.DEB.2.02.1302241029050.19612@chino.kir.corp.google.com>
References: <1361718944.2908.49.camel@falcor1.watson.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013, Mimi Zohar wrote:

> Fix a build error when CONFIG_BLOCK is not enabled, by defining
> a wrapper called blk_part_pack_uuid().  The wrapper returns
> -EINVAL, when CONFIG_BLOCK is not defined.
> 
> security/integrity/ima/ima_policy.c:538:4: error: implicit declaration
> of function 'part_pack_uuid' [-Werror=implicit-function-declaration]
> 
> Changleog v1:
> - rename ima_part_pack_uuid() to blk_part_pack_uuid()
> - resolve scripts/checkpatch.pl warnings
> Changelog v0:
> - fix UUID scripts/Lindent msgs
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
