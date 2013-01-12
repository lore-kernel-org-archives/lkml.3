Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3ALAo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:44:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54113 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3ALAo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:44:57 -0500
Message-ID: <50F0B207.8000205@wwwdotorg.org>
Date: Fri, 11 Jan 2013 17:44:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: tegra: remove USB address related macros from iomap.h
References: <1355805061-22789-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1355805061-22789-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 09:31 PM, Venu Byravarasu wrote:
> USB register base address and sizes defined in iomap.h
> are not used in any files other than board-dt-tegra20.c.
> Hence removed those defines from header file and using
> the absolute values in board files.

Thanks, applied to Tegra's for-3.9/usb branch.
