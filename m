Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaLAHpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:45:20 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50108 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaLAHpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:45:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,492,1413270000"; 
   d="scan'208";a="51768477"
Message-ID: <547C1C89.1070604@broadcom.com>
Date: Mon, 1 Dec 2014 08:45:13 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the driver-core tree
References: <20141201184205.08a8f7aa@canb.auug.org.au>
In-Reply-To: <20141201184205.08a8f7aa@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-12-14 08:42, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (arm
> multi_v7_defconfig) produced this warning:
> 
> In file included from kernel/power/main.c:16:0:
> include/linux/debugfs.h:105:10: warning: 'struct device' declared inside parameter list
>           void *data));
>           ^
> 
> And many more like this.
> 
> Introduced by commit 98210b7f73f1 ("debugfs: add helper function to
> create device related seq_file").  See Rule 1 from
> Documentation/SubmitChecklist - though in this case a simple "struct
> device;" would probably do.
> 

I submitted a patch for that yesterday [1] and got (automated) email
from Greg that it is going into his driver-core tree.

Regards,
Arend

[1] http://mid.gmane.org/1417361481-1136-1-git-send-email-arend@broadcom.com
