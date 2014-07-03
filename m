Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaGCNXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:23:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60044 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbaGCNXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:04 -0400
Date: Thu, 3 Jul 2014 15:22:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpc925_eadc: Use devm_ioremap_resource()
Message-ID: <20140703132255.GD21776@pd.tnic>
References: <1402324818-12300-1-git-send-email-wangkefeng.wang@huawei.com>
 <53966624.5060206@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53966624.5060206@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 09:57:56AM +0800, Kefeng Wang wrote:
> Convert to devm_ioremap_resource() to simplify code.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  drivers/edac/cpc925_edac.c |   30 ++++++------------------------
>  1 files changed, 6 insertions(+), 24 deletions(-)

Has this one been tested on the actual hardware?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
