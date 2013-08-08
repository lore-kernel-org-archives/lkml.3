Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3HHLjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:39:22 -0400
Received: from 219-118-191-131.cust.bit-drive.ne.jp ([219.118.191.131]:52881
	"EHLO mail.omesemicon.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab3HHLjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:39:21 -0400
X-Greylist: delayed 37556 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 07:39:21 EDT
Message-ID: <52038365.4000508@jinso.co.jp>
Date: Thu, 08 Aug 2013 20:39:17 +0900
From: Nguyen Viet Dung <nv-dung@jinso.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com
Subject: Re: [PATCH v2 1/1 resend] i2c: rcar: modify I2C driver
References: <1375687174-577-1-git-send-email-nv-dung@jinso.co.jp> <1375687174-577-2-git-send-email-nv-dung@jinso.co.jp> <20130807151234.GH2978@katana> <5202F0AC.4070609@jinso.co.jp> <20130808080819.GA6070@the-dreams.de>
In-Reply-To: <20130808080819.GA6070@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolffam

Thank for your advice.
I have understand what you have guided.

Time of 08/10~08/18 day is summer holiday in Japan.
Affter summer holiday, I am going modify the patch, and send again.

At that time,please check it for me.
Thanks,
Dung

On 08/08/2013 05:12 PM, Wolfram Sang wrote:
> On Thu, Aug 08, 2013 at 10:13:16AM +0900, Nguyen Viet Dung wrote:
>
>> Difference between H2 and H1 in hardware is only CDF bit of ICCCR register.
> No IP version register? Sigh...
>
>> If this method is not a common method, please tell me about common method.
> Use a new platform_device_id and populate the driver_data with the info
> needed to distinguish between the revisions. Check i2c-imx.c for an
> example.
>
>
>

