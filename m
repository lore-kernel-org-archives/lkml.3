Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaA2UCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:02:39 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50835 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaA2UCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:02:38 -0500
MIME-Version: 1.0
In-Reply-To: <1391025397-14965-1-git-send-email-jcmvbkbc@gmail.com>
References: <1391025397-14965-1-git-send-email-jcmvbkbc@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 29 Jan 2014 12:01:57 -0800
Message-ID: <CAGVrzcZQLO5t=kmYtUoPBRZG=HrZQTxD8B0K-yN+h-z4ZCRL7A@mail.gmail.com>
Subject: Re: [PATCH 0/4] OpenCores 10/100 MAC ethtool operations
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Gauthier <marc@cadence.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-29 Max Filippov <jcmvbkbc@gmail.com>:
> Hello David, Florian and everybody,
>
> this series implements ethtool callbacks for the ethoc driver as was
> requested by Florian.

Thanks Max, this does look good to me now:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

>
> Max Filippov (4):
>   net: ethoc: implement basic ethtool operations
>   net: ethoc: implement ethtool get/set settings
>   net: ethoc: implement ethtool get registers
>   net: ethoc: implement ethtool get/set ring parameters
>
>  drivers/net/ethernet/ethoc.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
>
> --
> 1.8.1.4
>



-- 
Florian
