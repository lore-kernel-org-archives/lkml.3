Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3FJRaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:30:13 -0400
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1225 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab3FJRaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:30:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23871
Message-ID: <51B60D25.2000302@metafoo.de>
Date: Mon, 10 Jun 2013 19:30:13 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 4/6] MIPS: jz4740: Register jz4740 DMA device
References: <1369931105-28065-1-git-send-email-lars@metafoo.de> <1369931105-28065-5-git-send-email-lars@metafoo.de> <51A78B45.1060604@cogentembedded.com>
In-Reply-To: <51A78B45.1060604@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 07:24 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 05/30/2013 08:25 PM, Lars-Peter Clausen wrote:
> 
>> Register a device for the newly added jz4740 dmaengine driver.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Acked-by: Ralf Baechle <ralf@linux-mips.org>
> [...]
>>   3 files changed, 23 insertions(+)
>> diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
>> index e9348fd..35a9d8c 100644
>> --- a/arch/mips/jz4740/platform.c
>> +++ b/arch/mips/jz4740/platform.c
>> @@ -329,3 +329,24 @@ struct platform_device jz4740_pwm_device = {
> [...]
>> +struct platform_device jz4740_dma_device = {
>> +    .name    = "jz4740-dma",
>> +    .id    = -1,
> 
>    Why not align all = in this structure?
> 

Will fix that in the next version, thanks.

- Lars
