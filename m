Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3J0L5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:57:09 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:47090 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3J0L5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:57:08 -0400
Date: Sun, 27 Oct 2013 07:57:03 -0400
From: Tejun Heo <tj@kernel.org>
To: xiangliang yu <yxlraid@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuxiangl@marvell.com
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
Message-ID: <20131027115703.GH14934@mtj.dyndns.org>
References: <CAP0P+NUQSByVNquY-zP3S-6GKhSvQXgq_4dDCTd2R8FM=YC_Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP0P+NUQSByVNquY-zP3S-6GKhSvQXgq_4dDCTd2R8FM=YC_Gg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 16, 2013 at 11:36:20AM +0800, xiangliang yu wrote:
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 34c8216..fbe592f 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -1266,9 +1266,11 @@ int ahci_do_softreset(struct ata_link *link,
> unsigned int *class,

Your patch is still completely white space corrupted.  Please check
your mail settings.  Using git-send-email is usually a good idea.  I'm
applying the patch manually this time but *please* make sure your mail
setup is working before posting things next time.

Thanks.

-- 
tejun
