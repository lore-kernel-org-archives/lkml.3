Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab3BYC7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:59:44 -0500
Received: from tundra.namei.org ([65.99.196.166]:57907 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464Ab3BYC7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:59:43 -0500
Date: Mon, 25 Feb 2013 13:59:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Randy Dunlap <rdunlap@infradead.org>, David Rientjes <rientjes@google.com>,
        axboe <axboe@kernel.dk>, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix part_pack_uuid() build error
In-Reply-To: <1361718944.2908.49.camel@falcor1.watson.ibm.com>
Message-ID: <alpine.LRH.2.02.1302251358200.25664@tundra.namei.org>
References: <1361718944.2908.49.camel@falcor1.watson.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013, Mimi Zohar wrote:

> Fix a build error when CONFIG_BLOCK is not enabled, by defining
> a wrapper called blk_part_pack_uuid().  The wrapper returns
> -EINVAL, when CONFIG_BLOCK is not defined.

Please indicate which tree your patches are intended for, also noting 
specific regression details if any (e.g. which commit introduced it).


-- 
James Morris
<jmorris@namei.org>
