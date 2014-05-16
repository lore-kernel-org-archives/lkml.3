Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaEPJSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:18:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:34438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712AbaEPJSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:18:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1066,1389772800"; 
   d="scan'208";a="540133897"
Message-ID: <1400231858.2458.389.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH staging-next] goldfish: pipe: fix warnings for 32bit
 builds
From: Alan Cox <alan@linux.intel.com>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        Jun Tian <jun.j.tian@intel.com>
Date: Fri, 16 May 2014 10:17:38 +0100
In-Reply-To: <1400217899-32261-2-git-send-email-octavian.purdila@intel.com>
References: <1400217899-32261-1-git-send-email-octavian.purdila@intel.com>
	 <1400217899-32261-2-git-send-email-octavian.purdila@intel.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 08:24 +0300, Octavian Purdila wrote:
> drivers/platform/goldfish/goldfish_pipe.c: In function 'goldfish_cmd_status':
> drivers/platform/goldfish/goldfish_pipe.c:164:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      writel((u32)(u64)pipe, dev->base + PIPE_REG_CHANNEL);
>                  ^
> drivers/platform/goldfish/goldfish_pipe.c: In function 'goldfish_cmd':
> drivers/platform/goldfish/goldfish_pipe.c:180:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      writel((u32)(u64)pipe, dev->base + PIPE_REG_CHANNEL);
>                  ^
> drivers/platform/goldfish/goldfish_pipe.c: In function 'goldfish_pipe_read_write':
> drivers/platform/goldfish/goldfish_pipe.c:337:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>        writel((u32)(u64)pipe, dev->base + PIPE_REG_CHANNEL);
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Jun Tian <jun.j.tian@intel.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Thanks...

Both

Acked-by: Alan Cox <alan@linux.intel.com>

