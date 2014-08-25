Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaHYIZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:25:25 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:43748 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaHYIZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140825081707.GA21712@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1408620803-10464-5-git-send-email-heikki.krogerus@linux.intel.com>
	<CAFp+6iEihFwvJA7qkdhkGrSGkgEZz4Qtm4CAU6h0Aq3zUt1bxw@mail.gmail.com>
	<20140825081707.GA21712@xps8300>
Date: Mon, 25 Aug 2014 13:55:19 +0530
X-Google-Sender-Auth: gK30e5eBzmya9P0Yzs3F_0F3Sa0
Message-ID: <CAFp+6iFUSdK7ZoiNFKOS1mYV0N8QLAOC+P3Dgi19wWzdsPAfxg@mail.gmail.com>
Subject: Re: [PATCH 4/6] phy: remove the old lookup method
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 1:47 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> On Mon, Aug 25, 2014 at 01:11:34PM +0530, Vivek Gautam wrote:
>> Please squash the attached diff which removes the 'init_data' field
>> from some of the other instances
>> of devm_phy_create() in few other drivers.
>> This should prevent any build errors that i could see with multi_v7_defconfig.
>
> OK, I'll add those changes into this patch, and it seems there
> is now at least one more new driver on top of those calling
> devm_phy_create.

Ok, i think i just saw this on 3.17-rc1.




-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
