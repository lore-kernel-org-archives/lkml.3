Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3K2IbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:31:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49909 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab3K2Ia4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:30:56 -0500
Message-ID: <5298507B.5050102@ti.com>
Date: Fri, 29 Nov 2013 13:59:47 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: Fix McASP mem resource names
References: <1384354097-1163-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1384354097-1163-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Wednesday 13 November 2013 08:18 PM, Peter Ujfalusi wrote:
> The ASoC McASP driver looks for the mem resources by name and:
> "mpu" and "dat" regions.
> Change/add the needed name for the mem resources so the driver can pick the
> correct resource.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Thanks for the patch. It does make the soundcard detect again on
DaVinci. Will queue for v3.13-rc3 (too late for -rc2, sorry!)

Thanks,
Sekhar

