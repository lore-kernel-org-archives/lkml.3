Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3KLXLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:11:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60415 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab3KLXLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:11:06 -0500
Message-ID: <5282B570.8020802@ti.com>
Date: Tue, 12 Nov 2013 17:10:40 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: maintain sane runtime pm status
 around suspend/resume
References: <1383857942-23630-1-git-send-email-nm@ti.com>	<87iow3rd3y.fsf@linaro.org> <527C2B78.2070201@ti.com>	<874n7npw1e.fsf@linaro.org> <20131111162358.GA6451@kahuna> <878uwtnwfc.fsf@linaro.org>
In-Reply-To: <878uwtnwfc.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 03:26 PM, Kevin Hilman wrote:
[..]
> Yes, the updated version looks much more sensible.  Please repost in its
> own thread so it gets a better chance at broader review, and feel free
> to add
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>

Thanks. this is done[1]

[1] https://patchwork.kernel.org/patch/3176501/


-- 
Regards,
Nishanth Menon
