Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab3FLRq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:46:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3017 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab3FLRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:46:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 12 Jun 2013 10:46:26 -0700
Message-ID: <51B8B3EF.40209@nvidia.com>
Date: Wed, 12 Jun 2013 13:46:23 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Anton Vorontsov <cbou@mail.ru>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] arm: tegra: Add power-supplies link between battery
 and charger
References: <1370899602-22123-1-git-send-email-rklein@nvidia.com> <1370899602-22123-5-git-send-email-rklein@nvidia.com> <51B8B389.8010105@wwwdotorg.org>
In-Reply-To: <51B8B389.8010105@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2013 1:44 PM, Stephen Warren wrote:
> On 06/10/2013 03:26 PM, Rhyland Klein wrote:
>> The power supply core now supports detecting linkages between batteries
>> and chargers through the use of the power-supplies property. Adding
>> this to the battery, the core will use the phandle list to find
>> the associated charger and pair them up. This facilitates notifications
>> from the charger to the battery when ac power is dissconnected
>> or connected for instance.
> 
> Rhyland, if I apply this patch without patches 1-3 being in the same
> branch, will it cause any bugs? If so, I guess 1-3 should go through the
> drivers/power maintainer for 3.11, and I should defer this patch to 3.12?
> 

No, this alone shouldn't cause a problem. Patches 2 & 3 enable the
support for using the power-supplies property in the charger and battery
drivers. Without them, this property will just be ignored for now.

--rhyland

-- 
nvpublic
