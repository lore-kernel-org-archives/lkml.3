Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3AOSEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:04:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50928 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3AOSEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:04:54 -0500
Message-ID: <50F59A43.7050308@wwwdotorg.org>
Date: Tue, 15 Jan 2013 11:04:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: remove unused APIs from Tegra PHY.
References: <1358245170-22083-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1358245170-22083-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 03:19 AM, Venu Byravarasu wrote:
> As tegra_usb_phy_clk_disable/enable() are not being
> used, removing them.

Greg, Felipe,

Again if I may, I'll take this through the Tegra tree. I think the next
set of patches that Venu posts should actually expose the dependencies
between his USB patches and the Tegra clock framework rework, which are
why I want to do this.
