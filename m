Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaHDIfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:35:01 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:53852 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaHDIe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:34:59 -0400
Message-ID: <53DF45AA.8080809@mentor.com>
Date: Mon, 4 Aug 2014 14:04:50 +0530
From: Vignesh Raman <Vignesh_Raman@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Jiada_Wang@mentor.com>
Subject: Re: [PATCH 2/2] dma: imx-sdma: Adding tasklet_kill() in sdma_remove
 function.
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com> <1406725875-9171-3-git-send-email-Vignesh_Raman@mentor.com> <20140731120205.GT8181@intel.com> <53DB9EFD.4040107@mentor.com> <20140801164524.GC8181@intel.com>
In-Reply-To: <20140801164524.GC8181@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 04 Aug 2014 08:34:58.0566 (UTC) FILETIME=[F9BE0260:01CFAFBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2014 10:15 PM, Vinod Koul wrote:
> On Fri, Aug 01, 2014 at 07:36:53PM +0530, Vignesh Raman wrote:
>> On Thursday 31 July 2014 05:32 PM, Vinod Koul wrote:
>>> On Wed, Jul 30, 2014 at 06:41:15PM +0530, Vignesh Raman wrote:
>>>> Several dma drivers calls tasklet_kill() in remove function. This is missing in
>>>> imx driver, so adding tasklet_kill() in sdma_remove function.
>>> And why should we do that ?
>>>
>> This is done because all running tasklets should be killed on remove.
> 
> And what prevents is from mentioning this in changelog!
> 

I should have mentioned in the Changelog but missed it, sorry about
that. I will add it and send updated version.

Regards,
Vignesh.
