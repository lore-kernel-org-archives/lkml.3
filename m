Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3HAQjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:39:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50165 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3HAQjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:39:13 -0400
Message-ID: <51FA8F2E.8080105@wwwdotorg.org>
Date: Thu, 01 Aug 2013 10:39:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: DTS: tegra: Add USB entries for Tegra30
References: <1375369218-11288-1-git-send-email-ttynkkynen@nvidia.com> <1375369218-11288-2-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375369218-11288-2-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 09:00 AM, Tuomas Tynkkynen wrote:
> Add device tree entries for the 3 USB controllers and PHYs and
> enable the third controller on Cardhu and Beaver boards.
> 
> Fix VBUS regulator entries on Beaver. The GPIO pins were wrong.
> Also, internal pullups need to be enabled on those pins.
> 
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
> v2: Use internal pullups on the VBUS regulator GPIOs.

Thanks, this version looks good.

Thierry, can you please validate that the gpv group pull strength change
doesn't have any negative affect on your PCIe patches. Thanks.
