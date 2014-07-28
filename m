Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaG1Gcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:32:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57922 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaG1Gcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:32:50 -0400
Message-ID: <53D5EE71.3040707@ti.com>
Date: Mon, 28 Jul 2014 12:02:17 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <joelf@ti.com>,
        <vinod.koul@intel.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM/dma: edma: Serve cyclic clients via high priority
 queue
References: <1404816398-12338-1-git-send-email-peter.ujfalusi@ti.com> <53D5E9CF.10706@ti.com>
In-Reply-To: <53D5E9CF.10706@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 11:42 AM, Peter Ujfalusi wrote:
> On 07/08/2014 01:46 PM, Peter Ujfalusi wrote:
>> Hi,
>>
>> It is preferred that audio is served with the highest priority queue in order to
>> avoid delays in data transfer between memory and audio IP.
>>
>> The following series will add an API to arch code to assign a channel to a given
>> queue.
>> The default queue is changed from 0 (highest priority) to lowest priority.

This should not really change any performance behavior as everything at
highest priority is same as everything at lowest priority.

>> In the dmaengine driver we move the cyclic channel to queue0 (highest priority)
>> and move it back to default queue when the channel is terminated.
> 
> ping?

For 1/3 and 2/3:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Vinod, can you take the series together with your tree (if you are happy
with the series, that is)? I don't have anything else queued for this
merge window.

Thanks,
Sekhar

