Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3EISCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:02:08 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52843 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3EISCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:02:07 -0400
Message-ID: <518BE49D.4080602@tilera.com>
Date: Thu, 9 May 2013 14:02:05 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Libo Chen <libo.chen@huawei.com>
CC: <stern@rowland.harvard.edu>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 4/4] usb: tilegx: fix memleak when create hcd fail
References: <1368079537-15328-1-git-send-email-libo.chen@huawei.com> <1368079537-15328-5-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1368079537-15328-5-git-send-email-libo.chen@huawei.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/2013 2:08 AM, Libo Chen wrote:
> When usb_create_hcd fail, we should call gxio_usb_host_destroy
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/ohci-tilegx.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

Thanks; taken into the tile tree.  I also made the same change to ehci-tilegx.c.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

