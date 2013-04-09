Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936670Ab3DIPt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:49:58 -0400
Received: from ozlabs.org ([203.10.76.45]:52918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936270Ab3DIPt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:49:56 -0400
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the vfs tree
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Apr 2013 01:49:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20130408111513.da2fc33b28669ede50622d67@canb.auug.org.au>
References: <20130408111513.da2fc33b28669ede50622d67@canb.auug.org.au>
Message-ID: <ff9ba0cbc139d6f4937a892ceb5b6e9c@ozlabs.org>
User-Agent: Roundcube Webmail/0.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 2013-04-08 11:15, Stephen Rothwell wrote:
>
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 
> 'kvm_init':
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:2990:2: error:
> assignment of member 'owner' in read-only object
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:2991:2: error:
> assignment of member 'owner' in read-only object
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:2992:2: error:
> assignment of member 'owner' in read-only object
>
> Caused by commit d612df096dce ("constify a bunch of struct
> file_operations instances").  Grep is your friend ...
>
> I have used the vfs tree from next-230130405 for today.

Ping?
-- 
Cheers,
Stephen Rothwell
