Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3HWSdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:33:40 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53026 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626Ab3HWSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:33:39 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 14:33:39 EDT
X-Sasl-enc: nwpW/t2gkDV+3PtYGWERNyHkfU5Atv+eJq5PWMQ+0sFn 1377282348
Message-ID: <5217A90B.5050902@ladisch.de>
Date: Fri, 23 Aug 2013 20:25:15 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: lm-sensors@lm-sensors.org
CC: Wei Hu <wei@aristanetworks.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (k10temp) Add support for Fam16h (Kabini)
References: <1377279498-2868-1-git-send-email-wei@aristanetworks.com>
In-Reply-To: <1377279498-2868-1-git-send-email-wei@aristanetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Hu wrote:
> The temperature reporting interface stays the same, so we just
> add the PCI-ID to the list.
>
> Verified on AMD Olive Hill.
> ---
>  Documentation/hwmon/k10temp |    1 +
>  drivers/hwmon/Kconfig       |    4 ++--
>  drivers/hwmon/k10temp.c     |    3 ++-
>  3 files changed, 5 insertions(+), 3 deletions(-)

Acked-by: Clemens Ladisch <clemens@ladisch.de>
