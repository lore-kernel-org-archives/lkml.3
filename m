Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaLSVul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 16:50:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaLSVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 16:50:40 -0500
Date: Fri, 19 Dec 2014 13:50:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: <m.szyprowski@samsung.com>, Michal Nazarewicz <mina86@mina86.com>,
        <aneesh.kumar@linux.vnet.ibm.com>, <iamjoonsoo.kim@lge.com>,
        <vishnu.ps@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH V2] CMA: add the amount of cma memory in meminfo
Message-Id: <20141219135038.6630669170af03914f9d6838@linux-foundation.org>
In-Reply-To: <54938052.3030809@huawei.com>
References: <54938052.3030809@huawei.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014 09:33:06 +0800 Xishi Qiu <qiuxishi@huawei.com> wrote:

> Add the amount of cma memory in the following meminfo.
> /proc/meminfo

We just did this.

> /sys/devices/system/node/nodeXX/meminfo

But not this.

See

commit 47f8f9297d2247d65ee46d8403a73b30f8d0249b
Author: Pintu Kumar <pintu.k@samsung.com>
Date:   Thu Dec 18 16:17:18 2014 -0800

    fs/proc/meminfo.c: include cma info in proc/meminfo

