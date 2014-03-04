Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaCDFH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:07:29 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45759 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaCDFH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:07:27 -0500
Date: Mon, 3 Mar 2014 21:07:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@iki.fi>
cc: Vegard Nossum <vegardno@ifi.uio.no>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, kmemcheck: Use kstrtoint() instead of sscanf()
In-Reply-To: <5314804F.9090806@iki.fi>
Message-ID: <alpine.DEB.2.02.1403032107020.21548@chino.kir.corp.google.com>
References: <5304558F.9050605@huawei.com> <alpine.DEB.2.02.1402182344001.3551@chino.kir.corp.google.com> <alpine.DEB.2.02.1402191412300.31921@chino.kir.corp.google.com> <5314804F.9090806@iki.fi>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014, Pekka Enberg wrote:

> > Kmemcheck should use the preferred interface for parsing command line
> > arguments, kstrto*(), rather than sscanf() itself.  Use it appropriately.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>
> 

Thanks!

> Andrew, can you pick this up?
> 

It's already picked up, see 
http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
