Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3A1PhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:37:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab3A1PhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:37:01 -0500
Message-ID: <1359387416.11144.177.camel@bling.home>
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
From: Alex Williamson <alex.williamson@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 08:36:56 -0700
In-Reply-To: <20130128212543.274a94d8021cfdabc3efc0e1@gmail.com>
References: <20130124220027.11061.76400.stgit@bling.home>
	 <20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
	 <5101FBE8.9000206@linux.vnet.ibm.com> <20130128105903.GA22871@redhat.com>
	 <20130128212543.274a94d8021cfdabc3efc0e1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 21:25 +0900, Takuya Yoshikawa wrote:
> On Mon, 28 Jan 2013 12:59:03 +0200
> Gleb Natapov <gleb@redhat.com> wrote:
> 
> > > It sets spte based on the old value that means the readonly flag check
> > > is missed. We need to call kvm_arch_flush_shadow_all under this case.
> > Why not just disallow changing memory region KVM_MEM_READONLY flag
> > without deleting the region?
> 
> Sounds good.
> 
> If you prefer, I can fold the required change into my patch.

That would seem to make my patch 1/2 unnecessary.  Thanks,

Alex

