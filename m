Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaHEG1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:27:42 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:45218 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaHEG1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:27:40 -0400
Message-ID: <53E07956.20502@mentor.com>
Date: Tue, 5 Aug 2014 11:57:34 +0530
From: Vignesh Raman <Vignesh_Raman@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Jiada_Wang@mentor.com>
Subject: Re: [PATCH 1/2] dma: imx-sdma: use module_platform_driver for SDMA
 driver
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com> <1406725875-9171-2-git-send-email-Vignesh_Raman@mentor.com> <20140731120011.GS8181@intel.com> <53DF471D.70407@mentor.com> <20140804083823.GO8181@intel.com>
In-Reply-To: <20140804083823.GO8181@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 05 Aug 2014 06:27:38.0694 (UTC) FILETIME=[5A6FCE60:01CFB076]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2014 02:08 PM, Vinod Koul wrote:
> On Mon, Aug 04, 2014 at 02:11:01PM +0530, Vignesh Raman wrote:
>> On Thursday 31 July 2014 05:30 PM, Vinod Koul wrote:
>>> On Wed, Jul 30, 2014 at 06:41:14PM +0530, Vignesh Raman wrote:
>>>> Currently there is no module_exit declared in SDMA driver, so that once
>>>> sdma module is inserted, it's shown with permanent attribute by lsmod,
>>>> and it can't be removed.
>>>> Use module_platform_driver to register/unregister SDMA driver and modify
>>>> SDMA's remove operation, to make SDMA driver possible to be removed.
>>> where is this bit below?
>>>
>> I'm not clear with your question. Are you asking about the unregister
>> SDMA driver function? It is done by dma_async_device_unregister.
> Driver already uses module_platform_driver, so I dont see what information
> the last two lines are trying to convey.
> 
> Patch needs to talk about what is done in current patch
> 
I missed some changes in Jiada's patch while merging to mainline kernel.
I will update and send the latest version.

Thanks,
Vignesh.
