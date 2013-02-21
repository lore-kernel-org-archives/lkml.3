Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3BUSdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:33:46 -0500
Received: from prdiron-1.llnl.gov ([128.15.143.171]:64209 "EHLO
	prdiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3BUSdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:33:45 -0500
X-Attachments: 
Date: Thu, 21 Feb 2013 10:33:44 -0800
From: Ira Weiny <weiny2@llnl.gov>
To: Ira Weiny <weiny2@llnl.gov>
Cc: "Husam Kahalah" <HKahalah@asaltech.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband-diags/saquery.c: switchinfo support added
Message-Id: <20130221103344.57aeda4abc1ac4915a6a0a06@llnl.gov>
In-Reply-To: <20130221100900.87b509d834fc0adc21b6f68b@llnl.gov>
References: <WC20130221094946.530170@asaltech.com>
	<20130221100900.87b509d834fc0adc21b6f68b@llnl.gov>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013 10:09:00 -0800
Ira Weiny <weiny2@llnl.gov> wrote:

[snip]

> > + ib_net16_t swir_lid;
> 
> We don't need this field or lid option.  Other records simply have an optional parameter to specify the lid.
> 
> The usage should be:
> 
> SwitchRecord [lid]
> 

Sorry I meant "SwitchInfoRecord" or SWIR.

Ira

[snip]
