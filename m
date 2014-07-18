Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbaGRK3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:29:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbaGRK3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:29:21 -0400
Message-ID: <53C8F6E6.6020901@redhat.com>
Date: Fri, 18 Jul 2014 12:28:54 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v5 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <1405667500-7402-1-git-send-email-mperttunen@nvidia.com> <53C8C9BD.3070709@nvidia.com>
In-Reply-To: <53C8C9BD.3070709@nvidia.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/18/2014 09:16 AM, Mikko Perttunen wrote:
> So here's v5: this time, as suggested, I handle the sata clock myself and let ahci_platform handle it too, leading it to be prepared+enabled twice. This works fine, and allows us to remove the DT ordering requirement.
> 
> I also have in the works a patchset that adds the name-based ahci_platform_get_resources function, but that is not quite ready yet, even if it is quite far along. Also, I am going on vacation and returning on 28.7., so if this v5 is acceptable maybe it could be merged for 3.17 and I could work on the new get_resources scheme after I get back from vacation?

Yes that works for me v3 of all the patches with no newer version +
v5 of patch 1 and 7 are pretty clean and can go into 3.17 from my pov,
Tejun can you pick these up for 3.17 please?

And thanks for working on a name-based ahci_platform_get_resources function
since what we've now in v5 is quite clean already I think it will be good
to take our time to get this right, so postponing this to 3.18 is fine
with me.

Regards,

Hans
