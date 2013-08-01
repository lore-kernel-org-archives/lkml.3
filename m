Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3HAVS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:18:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58799 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3HAVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:18:27 -0400
Message-ID: <51FAD0A0.1000208@wwwdotorg.org>
Date: Thu, 01 Aug 2013 15:18:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH 6/6] usb: host: tegra: Tegra30 support
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com> <1375292522-7855-7-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375292522-7855-7-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
> The Tegra30 EHCI controller is mostly compatible with the Tegra20
> controller, except Tegra30 includes the HOSTPC register extension.
> The has_hostpc capability bit must be set in the ehci_hcd structure if
> the controller has such extensions. The new tegra_ehci_soc_config
> structure is added to describe the differences between the SoCs.

Aside from the minor issues I already pointed out, the series briefly,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
