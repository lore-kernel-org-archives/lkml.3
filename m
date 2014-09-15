Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaIOJXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:23:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54726 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbaIOJXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:23:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,526,1406592000"; 
   d="scan'208";a="171468651"
Message-ID: <5416AFFD.5090207@citrix.com>
Date: Mon, 15 Sep 2014 11:23:09 +0200
From: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: <axboe@fb.com>, <felipe.franciosi@citrix.com>
Subject: Re: [Xen-devel] [PATCH RFC 0/4] Multi-queue support for xen-blkfront
 and xen-blkback
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 22/08/14 a les 13.20, Arianna Avanzini ha escrit:
> Hello,
[...]
> The patchset implements in the backend driver the retrieval of information
> about the currently-in-use block layer API for a certain device and about
> the number of available submission queues, if the API turns out to be the
> multi-queue one. The information is then advertised to the frontend driver
> via XenStore. The frontend device can exploit such an information to allocate
> and grant multiple I/O rings that the backend will be able to map.
> The patchset has been tested with fio's IOmeter emulation on a four-cores
> machine with a null_blk device (some results are available here: [2]).

Have you tried if using multiple queues (rings) between blkfront and
blkback even when the underlying device doesn't use MQ increases the
throughput?

Roger.

