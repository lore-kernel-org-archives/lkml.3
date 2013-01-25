Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3AYC7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:59:11 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39730 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3AYC67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:58:59 -0500
Message-ID: <5101F4E3.2020001@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 10:58:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: gleb@redhat.com, kvm@vger.kernel.org, yoshikawa_takuya_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: Force IOMMU remapping on memory slot read-only
 flag changes
References: <20130124220027.11061.76400.stgit@bling.home> <20130124220403.11061.61738.stgit@bling.home>
In-Reply-To: <20130124220403.11061.61738.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012502-3568-0000-0000-0000031361C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 06:04 AM, Alex Williamson wrote:
> Memory slot flags can be altered without changing other parameters of
> the slot.  The read-only attribute is the only one the IOMMU cares
> about, so generate an un-map, re-map when this occurs.  This also
> avoid unnecessarily re-mapping the slot when no IOMMU visible changes
> are made.
> 

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

