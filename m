Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3LBJxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:53:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab3LBJxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:53:44 -0500
Subject: Re: ping: re: [PATCH 1/1] kernel code that do not handle NULL return of kmem_cache_zalloc
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1812\))
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
X-Priority: 3
In-Reply-To: <e9c283.a967.142b14600da.Coremail.yizhouzhou@ict.ac.cn>
Date: Mon, 2 Dec 2013 10:54:51 +0100
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <65B0AD57-F44C-4360-916C-16D26884B09C@suse.de>
References: <1385549465-15945-1-git-send-email-yizhouzhou@ict.ac.cn> <e9c283.a967.142b14600da.Coremail.yizhouzhou@ict.ac.cn>
To: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
X-Mailer: Apple Mail (2.1812)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.12.2013, at 04:07, Zhouyi Zhou <yizhouzhou@ict.ac.cn> wrote:

> ping
>>  I do a grep for kmem_cache_zalloc and kmem_cache_alloc
>>  in kernel tree, and find some code do not handle NULL
>>  return of kmem_cache_zalloc correctly
>>  
>>  
>>  Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>

Thanks a lot for the patch. I'd assume we want something slightly more clever even, similar to Paul's d78bca729.

Please beware that it's usually not a good idea to post patches that span multiple subtrees. I don't want to apply a patch to my kvm tree that touches jffs2 for example, as that's out of my scope. It usually makes a maintainer's life easier if you split up a patch like this according to tree responsibilities.


Alex

