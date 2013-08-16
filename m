Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3HPMjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:39:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48533 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3HPMjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:39:21 -0400
Message-ID: <520E1C74.7080101@ti.com>
Date: Fri, 16 Aug 2013 18:05:00 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] ARM: davinci: fix clock lookup for mdio device
References: <1376546497-26931-1-git-send-email-prabhakar.csengg@gmail.com> <1376546497-26931-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376546497-26931-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 August 2013 11:31 AM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch removes the clock alias for mdio device and adds a entry
> in clock lookup table, this entry can now be used by both DT and NON
> DT case.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Queuing for v3.12

Thanks,
Sekhar

