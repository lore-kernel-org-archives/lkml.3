Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3CNF0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 01:26:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38216 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab3CNF0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 01:26:14 -0400
Message-ID: <51415F6D.1030503@ti.com>
Date: Thu, 14 Mar 2013 10:56:05 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>
Subject: Re: [PATCH 2/5] usb: musb: omap: always glue have the correct vbus/id
 status
References: <1363164430-19118-1-git-send-email-kishon@ti.com> <1363164430-19118-3-git-send-email-kishon@ti.com> <CANOLnOPG9Rbj=XNXtyeReoEzHpegSuZT0QKhEy7QdbVjO4OUPw@mail.gmail.com>
In-Reply-To: <CANOLnOPG9Rbj=XNXtyeReoEzHpegSuZT0QKhEy7QdbVjO4OUPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 March 2013 03:29 AM, Grazvydas Ignotas wrote:
> On Wed, Mar 13, 2013 at 10:47 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> In the case where omap glue is loaded and musb core is not, glue->status
>> wont have a valid status if the phy drivers call omap_musb_mailbox. So
>> fixed the conditions here.
>
> There already seems to be another patch named "usb: musb: omap2430:
> fix omap_musb_mailbox glue check again" on it's way to mainline that
> does mostly the same as first part of this patch.

Oh yeah. Missed that.

Thanks
Kishon
