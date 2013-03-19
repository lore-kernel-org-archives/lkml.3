Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3CST0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:26:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53192 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3CST0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:26:00 -0400
Message-ID: <5148BBC4.8050800@wwwdotorg.org>
Date: Tue, 19 Mar 2013 13:25:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 6/7] usb: phy: tegra: Add error handling & clean up.
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-7-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1363609781-4045-7-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
> Check return values from all GPIO APIs and handle errors accordingly.
> Remove clk_disable_unprepare which is no more needed.

Patches 6 and 7 each fail checkpatch with "WARNING: line over 80
characters".
