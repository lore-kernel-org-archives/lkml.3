Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3IBRJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:09:19 -0400
Received: from smtp-out-225.synserver.de ([212.40.185.225]:1449 "EHLO
	smtp-out-225.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3IBRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:09:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7294
Message-ID: <5224C69C.2090606@metafoo.de>
Date: Mon, 02 Sep 2013 19:10:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: dma_slave_caps: remove sg entries
References: <1378124519-13900-1-git-send-email-vinod.koul@intel.com> <5224A616.2060501@metafoo.de> <20130902161247.GA15824@intel.com>
In-Reply-To: <20130902161247.GA15824@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 06:12 PM, Vinod Koul wrote:
> On Mon, Sep 02, 2013 at 04:52:06PM +0200, Lars-Peter Clausen wrote:
>> On 09/02/2013 02:21 PM, Vinod Koul wrote:
>>> As pointed by Russell in [1], the sg properties are already availble in struct device,
>>> so no need to duplicate here.
>>>
>>> [1]: http://marc.info/?l=linux-omap&m=137416733628831
>>
>> Hm, I guess that will work as well, but shouldn't we update the drivers that
>> already implementing this interface first?
> Well thats why I cced you :). I have fixed up the pl330 driver. Have you used
> these values in any of the ASoC drivers?

Not in upstream yet, if the pl330 is fixed we are good.

- Lars

