Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaHTGuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:50:08 -0400
Received: from smtp-out-021.synserver.de ([212.40.185.21]:1062 "EHLO
	smtp-out-021.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaHTGuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:50:06 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4425
Message-ID: <53F4451B.3040209@metafoo.de>
Date: Wed, 20 Aug 2014 08:50:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: Sanjeev Sharma <sanjeev_sharma@mentor.com>, jic23@kernel.org,
        gregkh <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:iio: moved platform_data into include/linux/iio
References: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>	<53F441FF.9090304@metafoo.de> <CAGUYZuSENkSjoA9U0E8MQKp0a1J3moE8p8NYAzfiZ+BpxND4Aw@mail.gmail.com>
In-Reply-To: <CAGUYZuSENkSjoA9U0E8MQKp0a1J3moE8p8NYAzfiZ+BpxND4Aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 08:44 AM, sanjeev sharma wrote:
> Hi,
>
> This was the action item(TO-DO). IMO, it make sense to move into
> include/linux/iio because IIO complete subsystem may take some time.

The code that is in staging is not supposed to 'leak' outside of staging. So 
either you move the driver as a whole out of staging or leave it there, but 
do not move individual files of the driver out of staging. The action item 
is for when the driver is moved out of staging.
