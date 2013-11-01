Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3KAGMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:12:09 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:35483 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3KAGMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
References: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
	<1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
Date: Fri, 1 Nov 2013 14:12:06 +0800
Message-ID: <CABawtvMpY6BGRnjq1FvrmyBSqSnqOnRFH_hS8gOTNMxy9JVfGw@mail.gmail.com>
Subject: Re: Got iperf regression while intel_iommu is on, how to cut the cost
 of cache flushing
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,
   Thanks, hope it could kill the most pain of the regression.  I will
try them and report the result.

Ethan

> You might hit a known problem for some 10Gb links.
>
> 3.12-rc6 has the fixes already, and stable has some pending backports :
>
> commit 95bd09eb27507691520d39ee1044d6ad831c1168
> tcp: TSO packets automatic sizing
>
> commit c9eeec26e32e087359160406f96e0949b3cc6f10
> tcp: TSQ can use a dynamic limit
>
> Please check that current 3.12-rc6 is OK ?
>
>
>
