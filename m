Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaLERiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:38:51 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45432 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaLERit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:38:49 -0500
Date: Fri, 5 Dec 2014 17:38:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: using DMA-API on ARM
Message-ID: <20141205173839.GB31222@e104818-lin.cambridge.arm.com>
References: <5481794E.4050406@broadcom.com>
 <4565667.WCBuNmaazQ@wuerfel>
 <20141205111114.GQ11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205111114.GQ11285@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 11:11:14AM +0000, Russell King - ARM Linux wrote:
> In any case, wouldn't using a u64 type for "address" be better - isn't
> "long long" 128-bit on 64-bit architectures?

No, it's still 64-bit. There is no 128-bit integer in the C standard.

-- 
Catalin
