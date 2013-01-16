Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3APVt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:49:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43712 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab3APVtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:49:25 -0500
Message-ID: <50F72062.7060404@wwwdotorg.org>
Date: Wed, 16 Jan 2013 14:49:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/4] arm: tegra: Add DT nodes for Tegra USB PHY
References: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com> <1358343022-28919-2-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1358343022-28919-2-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 06:30 AM, Venu Byravarasu wrote:
> Add DT nodes for Tegra USB PHY along with related documentation.
> Also added a phandle property to controller DT node, for referring
> to connected PHY instance.

Just a quick reminder to Greg, Felipe, Alan: Once this series passes
review, I'll need to take it through the Tegra tree. (Sorry if I'm
belabouring that point). This patch in particular will interact with the
common clock framework changes that will very soon be in the Tegra tree.
