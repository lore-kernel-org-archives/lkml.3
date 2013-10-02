Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3JBXlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 19:41:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37948 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3JBXlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:41:06 -0400
Message-ID: <524CAEBE.5010305@ti.com>
Date: Wed, 2 Oct 2013 18:39:42 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>, <bcousson@baylibre.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: AM33XX: add ethernet alias's for am33xx
References: <1380736713-24678-1-git-send-email-dmurphy@ti.com>
In-Reply-To: <1380736713-24678-1-git-send-email-dmurphy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 October 2013 12:58 PM, Dan Murphy wrote:
> Set the alias for ethernet0 and ethernet1 so that uBoot
> can set the MAC address appropriately.
>
> Currently uBoot cannot find the alias and there for does not set the
> MAC address.
>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Tested this with beagle bone black.

Tested-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
