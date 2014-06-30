Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaF3LCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:02:23 -0400
Received: from imta22.fe.bosch.de ([139.15.243.26]:41714 "EHLO
	imta22.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaF3LCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:02:21 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2014 07:02:21 EDT
Message-ID: <53B141B9.2060401@de.bosch.com>
Date: Mon, 30 Jun 2014 12:53:45 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <mathieu.poirier@linaro.org>
CC: <linus.walleij@linaro.org>, <will.deacon@arm.com>,
        <linux@arm.linux.org.uk>, <daniel.thompson@linaro.org>,
        <robherring2@gmail.com>, <robbelibobban@gmail.com>, <Al.Grant@arm.com>,
        <patches@linaro.org>, <marcin.jabrzyk@gmail.com>,
        <linux-kernel@vger.kernel.org>, <arnd@linaro.org>,
        <panchaxari.prasannamurthy@linaro.org>, <r.sengupta@samsung.com>,
        <arve@android.com>, <Tony.Armitstead@arm.com>,
        <john.stultz@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <james.king@linaro.org>, <pratikp@codeaurora.org>, <varshney@ti.com>,
        <jonas.svennebring@avagotech.com>
Subject: Re: [PATCH 1/9 v2] coresight: add CoreSight core layer framework
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org> <1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.211.33]
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.06.2014 20:04, mathieu.poirier@linaro.org wrote:
> From: Pratik Patel <pratikp@codeaurora.org>
>
> CoreSight components are compliant with the ARM CoreSight
> architecture specification and can be connected in various
> topologies to suite a particular SoCs tracing needs. These trace
> components can generally be classified as sources, links and
> sinks. Trace data produced by one or more sources flows through
> the intermediate links connecting the source to the currently
> selected sink.
>
> CoreSight framework provides an interface for the CoreSight trace
> drivers to register themselves with. It's intended to build up a
> topological view of the CoreSight components and configure the
> right series of components on user input via debugfs.
>
> For eg., when enabling a source, framework builds up a path
> consisting of all the components connecting the source to the
> currently selected sink and enables all of them.
>
> Framework also supports switching between available sinks and
> also provides status information to user space applications
> through the debugfs interface.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>   .../devicetree/bindings/arm/coresight.txt          | 141 +++++
>   drivers/Kconfig                                    |   2 +

I wonder if

arch/arm/Kconfig.debug

wouldn't be better place for this?

Best regards

Dirk
