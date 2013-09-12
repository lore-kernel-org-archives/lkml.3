Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab3ILKQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:16:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40328 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab3ILKQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:16:42 -0400
Message-ID: <52319368.7010501@ti.com>
Date: Thu, 12 Sep 2013 15:41:52 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: remove deprecated IRQF_DISABLED
References: <1378537633-7232-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1378537633-7232-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 September 2013 12:37 PM, Michael Opdenacker wrote:
> This patch proposes to remove the IRQF_DISABLED flag from Davinci code ;)
> It's a NOOP since 2.6.35, and will be removed one day
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Thanks for the patch. Queuing for v3.13

~Sekhar
