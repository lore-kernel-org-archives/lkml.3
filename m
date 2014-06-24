Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaFXUdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:33:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:40609 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbaFXUds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:33:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,540,1400050800"; 
   d="scan'208";a="552732336"
Date: Tue, 24 Jun 2014 14:33:31 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Matias Bjorling <m@bjorling.me>
cc: Keith Busch <keith.busch@intel.com>, willy@linux.intel.com,
        sbradshaw@micron.com, axboe@fb.com, tom.leiming@gmail.com,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v8] NVMe: convert to blk-mq
In-Reply-To: <53A9CF5F.6040806@bjorling.me>
Message-ID: <alpine.LRH.2.03.1406241419080.4699@AMR>
References: <1402661396-19207-1-git-send-email-m@bjorling.me> <1402661396-19207-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406160931400.4699@AMR> <53A9CF5F.6040806@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Matias Bjorling wrote:
> Den 16-06-2014 17:57, Keith Busch skrev:
>> This latest is otherwise stable on my dev machine.
>
> May I add an Acked-by from you?

Totally up to Willy, but my feeling is "not just yet". I see the value
this driver provides, but I would need to give this to a customer and
hear their results before adding an "ack". It maybe a couple more weeks
before they'll be able to try it.
