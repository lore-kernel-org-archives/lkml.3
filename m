Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936549Ab3DKPes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:34:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1266 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936514Ab3DKPeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:34:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 11 Apr 2013 08:33:21 -0700
Message-ID: <5166D814.30400@nvidia.com>
Date: Thu, 11 Apr 2013 11:34:44 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] mfd: tps65090: Add compatible string for charger subnode
References: <1365614095-5846-1-git-send-email-rklein@nvidia.com> <20130410221721.GM4874@zurbaran>
In-Reply-To: <20130410221721.GM4874@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2013 6:17 PM, Samuel Ortiz wrote:
> Hi Rhyland,
> 
> On Wed, Apr 10, 2013 at 01:14:55PM -0400, Rhyland Klein wrote:
>> This patch adds the of_compatible value for the tps65090 charger
>> subnode used when loading the driver to find its properties
>> and of_node.
>>
>> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
>> ---
>>  drivers/mfd/tps65090.c |    1 +
>>  1 file changed, 1 insertion(+)
> Applied, thanks. And sorry for taking the wrong version.
> 
> Cheers,
> Samuel.
> 
Np, Thanks!

-rhyland

-- 
nvpublic
