Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaJHQOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:14:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:38275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbaJHQOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:14:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,678,1406617200"; 
   d="scan'208";a="585450026"
Date: Wed, 8 Oct 2014 10:13:48 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: thornber@redhat.com, snitzer@redhat.com, hch@infradead.org,
        hayakawa@valinux.co.jp, axboe@fb.com, andy@rudoff.com,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        linux-nvme@lists.infradead.org, jmad@itu.dk
Subject: Re: [PATCH 4/5] lightnvm: NVMe integration
In-Reply-To: <1412783736-18115-5-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1410081004310.4688@AMR>
References: <1412783736-18115-1-git-send-email-m@bjorling.me> <1412783736-18115-5-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1164306420-1412784831=:4688"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1164306420-1412784831=:4688
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 8 Oct 2014, Matias Bjørling wrote:
> NVMe devices are identified by the vendor specific bits:
>
> Bit 3 in OACS (device-wide). Currently made per device, as the nvme
> namespace is missing in the completion path.

The NVM-Express 1.2 actually defined this bit for Namespace Management,
so I don't think we can use bits the spec marked as "reserved". Maybe
you can trigger off some vendor specific Command Set Supported instead.
--8323328-1164306420-1412784831=:4688--
