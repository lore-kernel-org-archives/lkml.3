Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3LFP0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:26:07 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49045 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3LFP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:26:04 -0500
MIME-Version: 1.0
In-Reply-To: <CABawtvMpjy_=CS91g=9R3eJtdctRET9E4DZ=G_WrZaLtE89CGw@mail.gmail.com>
References: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
	<1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
	<CABawtvPSjm7LnE=nn6siJyoR+gf31iNA=ywSLz_0BR6rp_iK=w@mail.gmail.com>
	<1384220059.13547.17.camel@edumazet-glaptop2.roam.corp.google.com>
	<CABawtvMpjy_=CS91g=9R3eJtdctRET9E4DZ=G_WrZaLtE89CGw@mail.gmail.com>
Date: Fri, 6 Dec 2013 23:26:03 +0800
Message-ID: <CABawtvOcUzWQ_UOnB-NtkD6AxyfXKCO2pU3+hjrH-kHX+jV5nQ@mail.gmail.com>
Subject: Re: Got iperf regression while intel_iommu is on, how to cut the cost
 of cache flushing
From: Ethan Zhao <ethan.kernel@gmail.com>
To: jiang.liu@intel.com
Cc: Ashok Raj <ashok.raj@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang,
    Could you help to take a look such performance issue about Intel
IOMMU, seems you go back  this field of Intel.  Is it possible to
eliminate the performance side effect of mapping and unmapping
operation ? some context information, please refer to the first mail
of this loop.

Thanks,
Ethan
