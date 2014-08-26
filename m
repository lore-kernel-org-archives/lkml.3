Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbaHZKZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:25:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56856 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934354AbaHZKZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:25:22 -0400
Message-ID: <53FC6069.7000105@ti.com>
Date: Tue, 26 Aug 2014 15:54:41 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] ARM: DT/davinci: Audio for da850-evm in DT boot
References: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2014 11:43 AM, Peter Ujfalusi wrote:
> Hi,
> 
> Changes since v1:
> - fixed the address missmatch for tlv320aic3106 codec (@1b -> 18)
> - The edma patches has been taken by Vinod, they should be in linux-next soon.

I assume all of these 6 patches are meant to go through ARM SoC. I have
applied all of them for v3.18.

> The following series will enable audio via simple card on the board when booted
> with DT.

Thanks for doing this.

Regards,
Sekhar

