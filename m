Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3LSTUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:20:10 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52492 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3LSTUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:20:07 -0500
Message-ID: <52B346E1.2030508@wwwdotorg.org>
Date: Thu, 19 Dec 2013 12:20:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Danny Huang <dahuang@nvidia.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/6] misc: fuse: Add efuse driver for Tegra
References: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com> <1387468474-26521-3-git-send-email-pdeschrijver@nvidia.com> <20131219175931.GA18004@kroah.com>
In-Reply-To: <20131219175931.GA18004@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 10:59 AM, Greg KH wrote:
> On Thu, Dec 19, 2013 at 05:54:30PM +0200, Peter De Schrijver wrote:

>> +	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
>> +		tegra_revision_name[sku_info->revision],
>> +		sku_info->sku_id, sku_info->cpu_process_id,
>> +		sku_info->core_process_id);
> 
> Why pollute the kernel log with this type of thing?  Who really needs
> it?

We already print this; I guess this series is just moving where that
happens. It has proved useful to me in the past so I know which chip rev
I'm using, but I guess if this all gets exported to sysfs somewhere else
in this series, I could just go read those files in the future...
