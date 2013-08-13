Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab3HMSlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:41:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56484 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab3HMSla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:41:30 -0400
Message-ID: <520A7DD6.6050309@wwwdotorg.org>
Date: Tue, 13 Aug 2013 12:41:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Device tree changes for Tegra30 and Tegra114 USB
 Host support
References: <1375369218-11288-1-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375369218-11288-1-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 09:00 AM, Tuomas Tynkkynen wrote:
> Hi all,
> 
> Here's the device tree changes required for USB Host support on Tegra30 and
> Tegra114. This enables USB Host on the Cardhu's dock connector port and on the
> single built-in A-ports on Dalmore and Beaver.

I've applied this series to Tegra's for-3.12/dt branch, since Felipe has
applied the driver changes that back it up.
