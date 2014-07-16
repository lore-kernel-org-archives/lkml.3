Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030287AbaGPOsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030233AbaGPOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:48:07 -0400
Message-ID: <53C6908A.2050200@redhat.com>
Date: Wed, 16 Jul 2014 16:47:38 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <1405510814-31928-1-git-send-email-mperttunen@nvidia.com> <53C666E5.6030009@redhat.com> <20140716131306.GB23384@ulmo>
In-Reply-To: <20140716131306.GB23384@ulmo>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/16/2014 03:13 PM, Thierry Reding wrote:
> On Wed, Jul 16, 2014 at 01:49:57PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 07/16/2014 01:40 PM, Mikko Perttunen wrote:
>>> This patch adds device tree binding documentation for the SATA
>>> controller found on NVIDIA Tegra SoCs.
>>>
>>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>>> ---
>>> v4: clarify mandatory clock order
>>
>> Thanks this and the new v4 of "ata: Add support for the Tegra124 SATA controller"
>> both look good to me. So these 2 + v3 for the rest of the series are:
>>
>> Acked-by: Hans de Goede <hdegoede@redhat.com>
> 
> Like I said in my reply to PATCH v3 7/8, I think this mandatory clock
> order is a mistake.

We've plenty of other dt bindings where things need to be specified in
a certain order, e.g. registers. So I don't really see what the problem
is here.

Regards,

Hans
