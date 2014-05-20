Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaETJyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:54:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbaETJyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:54:43 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, xen-devel@lists.xenproject.org,
        felipe.franciosi@citrix.com, roger.pau@citrix.com,
        jerry.snitselaar@oracle.com, axboe@kernel.dk
Subject: Re: [Xen-devel] Backport request to stable of two performance related fixes for xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com>
	<8738g44wxp.fsf@vitty.brq.redhat.com>
Date: Tue, 20 May 2014 11:54:32 +0200
In-Reply-To: <8738g44wxp.fsf@vitty.brq.redhat.com> (Vitaly Kuznetsov's message
	of "Tue, 20 May 2014 11:32:50 +0200")
Message-ID: <87ppj8zsfb.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> 1) ramdisks (/dev/ram*) (persistent grants and indirect descriptors
> disabled)

sorry, there was a typo. persistent grants and indirect descriptors are
enabled with ramdisks, otherwise such testing won't make any sense.

> 2) /tmp/img*.img on tmpfs (persistent grants and indirect descriptors disabled)
>

-- 
  Vitaly Kuznetsov
