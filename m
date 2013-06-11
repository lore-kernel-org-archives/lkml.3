Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3FKLmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:42:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47424 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab3FKLmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:42:53 -0400
Message-ID: <51B70D1B.1080208@ti.com>
Date: Tue, 11 Jun 2013 17:12:19 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/11] gpio: davinci: coding style correction
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com> <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2013 12:40 PM, Philip Avinash wrote:
> 1. Corrects coding and commenting styles
> 2. Variables name change to meaningful name
> 3. Remove unnecessary variable usage
> 4. Add BINTEN macro definition
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

As Russell mentioned, the 80 char limit changes are churn. I looked at
the variable name renaming and that's also churn with little benefit.
The only changes that are probably worth doing are alphabetical ordering
of include files, fixes for mult-line commenting style and usage of
macro for register offset.

As I started reviewing these patches, I also started fixing some of the
comments I had and I have pushed the resulting work here:

https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git/log/?h=devel-gpio

It is only compile tested, but I hope this will serve as good starting
point for your next submission.

Thanks,
Sekhar
