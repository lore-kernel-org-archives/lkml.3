Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3K1I5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:57:05 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60157 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3K1I5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:57:03 -0500
Message-ID: <52970536.7040709@koalo.de>
Date: Thu, 28 Nov 2013 09:56:22 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
References: <529303EE.4080606@koalo.de> <20131128085017.GC2626@katana>
In-Reply-To: <20131128085017.GC2626@katana>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much!
I am sorry and will try to make it better next time.

On 11/28/2013 09:50 AM, Wolfram Sang wrote:
> On Mon, Nov 25, 2013 at 09:01:50AM +0100, Florian Meier wrote:
>> In order to find I2C devices in the device tree, the platform nodes
>> have to be known by the I2C core. This requires setting the
>> dev.of_node parameter of the adapter.
>>
>> Signed-off-by: Florian Meier <florian.meier@koalo.de>
> 
> Fixed up for you and applied to for-current. But PLEASE fix your mailer!
> 
