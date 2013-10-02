Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3JBK7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:59:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:41752 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3JBK7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1018,1371106800"; 
   d="scan'208";a="412901875"
Message-ID: <524BFD92.8030406@linux.intel.com>
Date: Wed, 02 Oct 2013 14:03:46 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio/lynxpoint: check if the interrupt is enabled in
 IRQ handler
References: <1380638143-20040-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1380638143-20040-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 05:35 PM, Mika Westerberg wrote:
> Checking LP_INT_STAT is not enough in the interrupt handler because its
> contents get updated regardless of whether the pin has interrupt enabled or
> not. This causes the driver to loop forever for GPIOs that are pulled up.
>
> Fix this by checking the interrupt enable bit for the pin as well.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>

