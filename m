Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3FQXa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:30:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:5342 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3FQXa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="318512835"
Date: Tue, 18 Jun 2013 01:30:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: ptyser@xes-inc.com, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 10/24] drivers/mfd/lpc_ich: Convert to module_pci_driver
Message-ID: <20130617233022.GX7998@zurbaran>
References: <1369621736-34664-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369621736-34664-1-git-send-email-libo.chen@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Libo,


On Mon, May 27, 2013 at 10:28:56AM +0800, Libo Chen wrote:
> use module_pci_driver instead of init/exit, make code clean.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/mfd/lpc_ich.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
