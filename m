Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3HPQOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:14:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35462 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3HPQOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:14:36 -0400
Message-ID: <520E4FCF.8010701@ti.com>
Date: Fri, 16 Aug 2013 21:44:07 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 2/2] ARM: davinci: da850: add OF_DEV_AUXDATA entry
 for davinci_emac
References: <1376662262-21795-1-git-send-email-prabhakar.csengg@gmail.com> <1376662262-21795-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376662262-21795-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/2013 7:41 PM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Add OF_DEV_AUXDATA for ethernet davinci_emac driver in da850 board dt
> file to use emac clock.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Queuing this for v3.12. Please fix the address of devicetree list in
future submissions.

Thanks,
Sekhar
