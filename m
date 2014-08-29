Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaH2Lvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:51:47 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:36483 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaH2Lvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:51:46 -0400
Message-ID: <5400694C.4040303@de.ibm.com>
Date: Fri, 29 Aug 2014 13:51:40 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: WARNING: at kernel/workqueue.c:845
References: <54005AFB.2010604@de.ibm.com>
In-Reply-To: <54005AFB.2010604@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082911-1948-0000-0000-000000F41607
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 12:50, Christian Borntraeger wrote:
> Tejun,
> 
> with kvm/next (pretty close to 3.17-rc1) as KVM guest I get the following warning in one of my stress tests:

Turns out that it happens when I shutdown the guest via an sclp quiesce interrupt (wired to ctrl-alt-delete)
and it also happens with 3.16, just less often. So I will some other places first.

Christian

