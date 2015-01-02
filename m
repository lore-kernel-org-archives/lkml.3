Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbbABSrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:47:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18555 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbABSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:47:46 -0500
Message-ID: <54A6E79E.7010203@oracle.com>
Date: Fri, 02 Jan 2015 10:46:54 -0800
From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH V2 0/2] ARM: l2c: OMAP4/AM437x: Additional register programming
 support.
References: <1420220628-23742-1-git-send-email-nm@ti.com>
In-Reply-To: <1420220628-23742-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/15 9:43 AM, Nishanth Menon wrote:
> Hi,
> OMAP4 and AM437x ROM code provides services to program PL310's latency
> registers and AM437x provides service for programming Address filter
> registers.
>
> Provide support in the kernel for the same.
>
> V2 of the series contains documentation update and a bug fix due to a
> typo introduced during patch split :(
>
> Nishanth Menon (2):
>    ARM: l2c: OMAP4/AM437x: Introduce support for cache latency
>      programming
>    ARM: l2c: AM437x: Introduce support for cache filter programming
>
Looks fine to me ...
Feel free to add my ack if you need one ...

Minor: The subject looks like I2C though it is L2C ;-)

