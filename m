Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3FQMYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:24:07 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39294 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836Ab3FQMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:24:04 -0400
Message-ID: <51BEFFD4.6090904@linux.vnet.ibm.com>
Date: Mon, 17 Jun 2013 20:23:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Glauber Costa <glommer@openvz.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with the kvm tree
References: <20130617180735.c10c058469ce0633c65225a4@canb.auug.org.au>
In-Reply-To: <20130617180735.c10c058469ce0633c65225a4@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061712-2000-0000-0000-00000C86E81A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for your work!

On 06/17/2013 04:07 PM, Stephen Rothwell wrote:

> - 		prepare_zap_oldest_mmu_page(kvm, &invalid_list);
> + 		freed += prepare_zap_oldest_mmu_page(kvm, &invalid_list);

It seems this change is not needed? and "freed" is not defined in mmu_shrink().
Right?

