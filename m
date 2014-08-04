Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaHDIlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:41:09 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:54173 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaHDIlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:41:07 -0400
Message-ID: <53DF471D.70407@mentor.com>
Date: Mon, 4 Aug 2014 14:11:01 +0530
From: Vignesh Raman <Vignesh_Raman@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Jiada_Wang@mentor.com>
Subject: Re: [PATCH 1/2] dma: imx-sdma: use module_platform_driver for SDMA
 driver
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com> <1406725875-9171-2-git-send-email-Vignesh_Raman@mentor.com> <20140731120011.GS8181@intel.com>
In-Reply-To: <20140731120011.GS8181@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 04 Aug 2014 08:41:06.0525 (UTC) FILETIME=[D51018D0:01CFAFBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2014 05:30 PM, Vinod Koul wrote:
> On Wed, Jul 30, 2014 at 06:41:14PM +0530, Vignesh Raman wrote:
>> Currently there is no module_exit declared in SDMA driver, so that once
>> sdma module is inserted, it's shown with permanent attribute by lsmod,
>> and it can't be removed.
>> Use module_platform_driver to register/unregister SDMA driver and modify
>> SDMA's remove operation, to make SDMA driver possible to be removed.
> where is this bit below?
> 
I'm not clear with your question. Are you asking about the unregister
SDMA driver function? It is done by dma_async_device_unregister.

Regards,
Vignesh.
