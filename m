Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424Ab3FTLHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:07:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60897 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965163Ab3FTLHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:07:11 -0400
Message-ID: <51C2E23A.5070409@ti.com>
Date: Thu, 20 Jun 2013 16:36:34 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ARM: davinci: da850: Use #include for all device
 trees
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com> <1371203156-15260-2-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1371203156-15260-2-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:15 PM, Philip Avinash wrote:
> Replace /include/ by #include for da850 device tree files, in order to
> use the C pre-processor, making use of #define features possible.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Added this to my v3.11/dt branch.

Thanks,
Sekhar
