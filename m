Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3A1MZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:25:53 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65334 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3A1MZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:25:50 -0500
Date: Mon, 28 Jan 2013 21:25:43 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
Message-Id: <20130128212543.274a94d8021cfdabc3efc0e1@gmail.com>
In-Reply-To: <20130128105903.GA22871@redhat.com>
References: <20130124220027.11061.76400.stgit@bling.home>
	<20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<5101FBE8.9000206@linux.vnet.ibm.com>
	<20130128105903.GA22871@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013 12:59:03 +0200
Gleb Natapov <gleb@redhat.com> wrote:

> > It sets spte based on the old value that means the readonly flag check
> > is missed. We need to call kvm_arch_flush_shadow_all under this case.
> Why not just disallow changing memory region KVM_MEM_READONLY flag
> without deleting the region?

Sounds good.

If you prefer, I can fold the required change into my patch.

	Takuya
