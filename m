Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3FXRk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:40:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51939 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3FXRkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:40:25 -0400
Message-ID: <51C8847E.5020101@atmel.com>
Date: Mon, 24 Jun 2013 19:40:14 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dan Williams <djbw@fb.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] at_hdmac: prepare clk before calling enable
References: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com> <1371640494-9472-1-git-send-email-b.brezillon@overkiz.com> <51C2B2B8.2040104@atmel.com> <20130621024039.GA23141@intel.com>
In-Reply-To: <20130621024039.GA23141@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/2013 04:40, Vinod Koul :
> On Thu, Jun 20, 2013 at 09:43:52AM +0200, Nicolas Ferre wrote:
>> On 19/06/2013 13:14, Boris BREZILLON :
>>> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
>>> avoid common clk framework warnings.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> BTW Vinod, it seems that we have several slave-dma patches pending:
>> do you want me to collect them and send you a pull-request for 3.11?
> I think those are the DT binding one, right? Sorry have been quite busy and
> travelling. I could use the help right now...

Vinod,

I have just sent the pull-request with all patches that you may take for 
3.11 ([GIT PULL] dmaengine: at_hdmac: updates for 3.11). It is a signed 
tag "at91-sdma" on our github space.

I hope that it will be easy for you to take it in your slave-dma git 
tree. If you have any question, please let me know.

Best regards,
-- 
Nicolas Ferre
