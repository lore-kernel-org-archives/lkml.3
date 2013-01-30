Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3A3E0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 23:26:32 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:43500 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3A3E03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 23:26:29 -0500
Date: Wed, 30 Jan 2013 13:26:21 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
Message-Id: <20130130132621.6752bb30.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <51089C48.9060108@linux.vnet.ibm.com>
References: <20130124220027.11061.76400.stgit@bling.home>
	<20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<5101FBE8.9000206@linux.vnet.ibm.com>
	<20130128105903.GA22871@redhat.com>
	<51073CC3.8030105@linux.vnet.ibm.com>
	<20130129065049.GF22871@redhat.com>
	<51077C33.60402@linux.vnet.ibm.com>
	<20130129074852.GH22871@redhat.com>
	<51089C48.9060108@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 12:06:32 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> >>>> So, i guess we can do the simple fix first.
> >>>>
> >>> By simple fix you mean calling kvm_arch_flush_shadow_all() on READONLY
> >>> flag change?
> >>
> >> Simply disallow READONLY flag changing.
> > Ok, can somebody craft a patch?
> 
> Takuya, will you? ;)

I will.
Thank you for pointing out the problem.

We can revisit the API later to determine what kind of changes
should be allowed.

	Takuya
