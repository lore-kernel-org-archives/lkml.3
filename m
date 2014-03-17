Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaCQNQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:16:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23614 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbaCQNQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:16:33 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-69-5326f5b03b19
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Oliver Schinagl <oliver@schinagl.nl>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci_sunxi: disable resources on driver removal
Date: Mon, 17 Mar 2014 14:16:16 +0100
Message-id: <1541332.S2AMpmTS9V@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <4639408.hubNkUp5Oa@amdc1032>
References: <4639408.hubNkUp5Oa@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jAd0NX9WCDWY8krR4c3w6k8Wmx9dY
	LY7teMRkcXnXHDaLrZv2Mlu8nPSQ1eLX8qOMDuweTzZdZPTYtKqTzWPzknqP9/uusnm0tixn
	9fi8SS6ALYrLJiU1J7MstUjfLoErY1/3WcaC9cwVOz7eZ2lgfMrUxcjJISFgInGg6SorhC0m
	ceHeerYuRi4OIYFFjBKXGxdBOS1MEs0/PoNVsQlYSUxsX8UIYosIyEpcmfaQEaSIWeAJo8SC
	k1vZQBLCAp4ScxcdZAaxWQRUJe5d3Axm8wpoSrzcPhvMFgWq2bF9JVg9p4CWxJOOT2BDhYBq
	1p1cywZRLyjxY/I9FhCbWUBeYt/+qawQtpbE+p3HmSYwCsxCUjYLSdksJGULGJlXMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgQH/DPpHYyrGiwOMQpwMCrx8E5QVgsWYk0sK67MPcQowcGs
	JMLr9A4oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgdFN
	mN3HolpcYwNL9utyfvsj7XLCeYuWyx/S1zZOzXbiOS2+pSnIdv8nNaOlXOubXm/dwarJ8HjJ
	rDVeJRZmqZHWCyd949G0vCpj/+DivfeXE1/trOQ5Ej7N2t0krKRFazrL9/tqD2zun1dTO598
	+jtnn4mWl9NJhWCv+QZp5nuUuWfV5C74oMRSnJFoqMVcVJwIAMxgTyB0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 17, 2014 02:05:15 PM Bartlomiej Zolnierkiewicz wrote:
> Add custom ->host_stop method to disable resources on driver removal.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

After looking some more into ahci_platform.c it seems that this patch
is not needed, sorry for the noise.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

