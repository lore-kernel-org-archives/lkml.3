Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbaJNMkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:40:17 -0400
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1077 "EHLO
	smtp-out-243.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaJNMkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:40:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31962
Message-ID: <543D19A9.5010109@metafoo.de>
Date: Tue, 14 Oct 2014 14:40:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RESEND PATCH v2 1/4] dmaengine: pl330: Remove non-NULL check
 for pl330_submit_req parameters
References: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com> <20141014115118.GG1638@intel.com>
In-Reply-To: <20141014115118.GG1638@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 01:51 PM, Vinod Koul wrote:
> On Mon, Sep 29, 2014 at 02:42:18PM +0200, Krzysztof Kozlowski wrote:
>> The pl330_submit_req() checked supplied 'struct pl330_thread thrd' and
>> 'struct dma_pl330_desc desc' parameters for non-NULL. However these
>> checks are useless because supplied arguments won't be NULL.
> even if we have some error or bug?
>
> I would like this to be checked and complained loudly so we know something
> is going wrong rather than assuming it will be correct always.
>

In this case it is impossible to get to this code portion if the pointer is 
NULL because it would have crashed earlier.

- Lars
