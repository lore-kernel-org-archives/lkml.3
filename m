Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3FGILs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:11:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47001 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3FGILi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:11:38 -0400
Message-ID: <51B1958C.3050704@ti.com>
Date: Fri, 7 Jun 2013 13:40:52 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] Convert GPIO Davinci to platform driver
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avinash,

On 5/22/2013 12:40 PM, Philip Avinash wrote:
> GPIO Davinci driver converted to platform driver to support DT booting.
> In this patch series
> - Cleaned gpio Davinci driver code with proper commenting style and appropriate
>   variable names.
> - Create platform driver for GPIO Davinci in da8xx and dm* platforms and removed
>   gpio related member updation in davinci_soc_info structure.
> - DT support added for da850 board and tested on da850 EVM.
> - Remove soc_info reference in the gpio davinci driver and start uses
>   gpiolib interface.

Can you please document which platforms this series was tested on and how?

Thanks,
Sekhar
