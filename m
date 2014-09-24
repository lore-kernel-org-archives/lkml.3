Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaIXJep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:34:45 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:59037 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751989AbaIXJen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:34:43 -0400
Message-ID: <5422902C.4020005@atmel.com>
Date: Wed, 24 Sep 2014 17:34:36 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] misc: atmel-ssc: prepare clock only when request
References: <1411549019-12663-1-git-send-email-voice.shen@atmel.com> <20140924090736.GC16977@sirena.org.uk>
In-Reply-To: <20140924090736.GC16977@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 09/24/2014 05:07 PM, Mark Brown wrote:
> On Wed, Sep 24, 2014 at 04:56:59PM +0800, Bo Shen wrote:
>> Prepare SSC clock only when request SSC channel, the clock will be
>> enabled when initialize the SSC.
>
> You should send this to the drivers/misc maintainer.

Thanks, it has been done.

Best Regards,
Bo Shen

