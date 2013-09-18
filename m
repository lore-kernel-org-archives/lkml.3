Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3IRP2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:28:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39301 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3IRP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:28:46 -0400
Message-ID: <5239C6AC.10403@nvidia.com>
Date: Wed, 18 Sep 2013 09:28:44 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH REPOST] ARM: tegra: use dt-binding header for key code
References: <1379510552-23401-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379510552-23401-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 07:22 AM, Laxman Dewangan wrote:
> In place of hardcoding the key code in DTS file and comment the
> key code as side notes, use the key code macro defines in the
> dt-bindings/input/input.h directly.

I can apply this, but aren't there many other Tegra DT files that need
conversion too?
