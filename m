Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3FEHQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:16:33 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44007 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3FEHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:16:32 -0400
Message-ID: <51AEE574.8040602@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 15:15:00 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] workqueue: code refine/clean for workqueue
References: <51AEE452.8080605@linux.vnet.ibm.com>
In-Reply-To: <51AEE452.8080605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060507-5490-0000-0000-0000039673D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 03:10 PM, Michael Wang wrote:
> Code refine/clean patch set for workqueue.
> 
> Michael Wang (3):
> 	[PATCH 1/3] workqueue: move the internal helper from .h to .c
> 	[PATCH 2/3] workqueue: remove the unused helper in .h
> 	[PATCH 3/3] workqueue: add a check point in pwq_activate_delayed_work()
	[PATCH 4/3] workqueue: code refine in wqattrs_equal()

Lost one...

Regards,
Michael Wang

> 
> ---
>  b/include/linux/workqueue.h |    5 -----
>  b/kernel/workqueue.c        |    5 +++++
>  include/linux/workqueue.h   |   27 ---------------------------
>  kernel/workqueue.c          |    6 +++---
>  4 files changed, 8 insertions(+), 35 deletions(-)
> 

