Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab3GXRJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:09:40 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2366 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3GXRJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:09:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 24 Jul 2013 10:08:26 -0700
Message-ID: <51F00A4E.1020100@nvidia.com>
Date: Wed, 24 Jul 2013 13:09:34 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Joseph Lo <josephl@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] regulator: palmas: fix pdata ptr not be updated after
 it has been allocated
References: <1374683282-17517-1-git-send-email-rklein@nvidia.com> <20130724170215.GP9858@sirena.org.uk>
In-Reply-To: <20130724170215.GP9858@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/2013 1:02 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Wed, Jul 24, 2013 at 12:28:02PM -0400, Rhyland Klein wrote:
> 
>> +	/* Store the pdata pointer after everything else passes */
>> +	pdev->dev.platform_data = pdata;
> 
> No, this is bad - the driver should not be modifying the platform_data
> pointer, it's owned by the thing that created the device.  If the
> platform data needs to be modified it should be copied somewhere in the
> driver data.

Alright, thanks.

-rhyland

> 
> * Unknown Key
> * 0x7EA229BD
> 


-- 
nvpublic
