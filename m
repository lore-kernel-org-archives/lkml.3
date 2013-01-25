Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3AYBRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:17:34 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:52619 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3AYBRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:17:25 -0500
Date: Fri, 25 Jan 2013 10:17:04 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
Message-Id: <20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20130124220027.11061.76400.stgit@bling.home>
References: <20130124220027.11061.76400.stgit@bling.home>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013 15:03:57 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> A couple patches to make KVM IOMMU support honor read-only mappings.
> This causes an un-map, re-map when the read-only flag changes and
> makes use of it when setting IOMMU attributes.  Thanks,

Looks good to me.

I think I can naturally update my patch after this gets merged.

Thanks,
	Takuya
