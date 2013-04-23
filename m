Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3DWTHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:07:42 -0400
Received: from void.printf.net ([89.145.121.20]:48086 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab3DWTHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:07:41 -0400
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 12/21] mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
	<1366734653-488286-13-git-send-email-arnd@arndb.de>
	<87bo95tctk.fsf@octavius.laptop.org>
	<201304232055.32715.arnd@arndb.de>
Date: Tue, 23 Apr 2013 15:07:35 -0400
In-Reply-To: <201304232055.32715.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 23 Apr 2013 20:55:32 +0200")
Message-ID: <8738uht6a0.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 23 2013, Arnd Bergmann wrote:
>> I was going to take this, but it doesn't apply to mmc-next or
>> linux-next, because the #endif in your first line of context isn't
>> present in those trees -- which tree is this based on?
>
> I based it on 3.9-rc8.

Thanks, I should have thought of that; applied to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
