Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaDQNb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:31:56 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:42917 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaDQNbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:31:55 -0400
Date: Thu, 17 Apr 2014 09:31:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com,
        Kefeng Wang <kefeng.wang@linaro.org>
Subject: Re: [PATCH V2 2/2] ahci: add support for Hisilicon sata
Message-ID: <20140417133151.GC15326@htj.dyndns.org>
References: <1397107468-640-1-git-send-email-wangkefeng.wang@huawei.com>
 <1397107468-640-3-git-send-email-wangkefeng.wang@huawei.com>
 <20140416204917.GB26632@htj.dyndns.org>
 <534F8733.1080009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534F8733.1080009@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:48:03AM +0200, Hans de Goede wrote:
> > Hmmm.... this should work but looks a bit tedious and it could be
> > better to have a better mechanism to match devices to their
> > port_infos.  Hans, can you please comment?  If getting something more
> > structured is too much work, I can go with this but wanna find out
> > whether that's the case.
> 
> The more structured solution would be v1 of this patch, which I asked
> Kefan to change since it seemed overkill. But if you prefer that version
> that is fine with me.

I don't care either way at this point but if this grows to a large
list, having a matching mechanism will probably be more manageable.

> Note that as I've already mentioned earlier in the thread this could be
> made somewhat cleaner by having an host_flags parameter to
> ahci_platform_init_host().

Kefeng, can you please update accordingly to Hans' comment and repost?

Thanks.

-- 
tejun
