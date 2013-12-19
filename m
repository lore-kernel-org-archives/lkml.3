Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3LSTnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:43:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab3LSTnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:43:37 -0500
Date: Thu, 19 Dec 2013 11:43:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Danny Huang <dahuang@nvidia.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/6] misc: fuse: Add efuse driver for Tegra
Message-ID: <20131219194340.GB1443@kroah.com>
References: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com>
 <1387468474-26521-3-git-send-email-pdeschrijver@nvidia.com>
 <20131219175931.GA18004@kroah.com>
 <52B346E1.2030508@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B346E1.2030508@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 12:20:01PM -0700, Stephen Warren wrote:
> On 12/19/2013 10:59 AM, Greg KH wrote:
> > On Thu, Dec 19, 2013 at 05:54:30PM +0200, Peter De Schrijver wrote:
> 
> >> +	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
> >> +		tegra_revision_name[sku_info->revision],
> >> +		sku_info->sku_id, sku_info->cpu_process_id,
> >> +		sku_info->core_process_id);
> > 
> > Why pollute the kernel log with this type of thing?  Who really needs
> > it?
> 
> We already print this; I guess this series is just moving where that
> happens. It has proved useful to me in the past so I know which chip rev
> I'm using, but I guess if this all gets exported to sysfs somewhere else
> in this series, I could just go read those files in the future...

I don't see this being exported anywhere else, or at least, if it is, it
sure isn't being documented...

greg k-h
