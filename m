Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaDGWMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:12:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55892 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaDGWMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140407.144258.2113005286706932770.davem@davemloft.net>
References: <1396898623-31667-1-git-send-email-haiyangz@microsoft.com>
	<20140407.144258.2113005286706932770.davem@davemloft.net>
Date: Mon, 7 Apr 2014 16:12:35 -0600
Message-ID: <CAJzFV36G7Qq1jc1nNkU2h19=c3-N-q9SEOmyMobCRwdirf0+vQ@mail.gmail.com>
Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive Side
 Scaling (vRSS)
From: Sharat Masetty <sharat04@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: haiyangz@microsoft.com, Linux Netdev List <netdev@vger.kernel.org>,
        kys@microsoft.com, olaf@aepfle.de, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang,

How is this beneficial when compared to RPS(receive packet steering)?
Can you please provide more details on what this patch does?

Thanks
Sharat


On Mon, Apr 7, 2014 at 12:42 PM, David Miller <davem@davemloft.net> wrote:
>
> The net-next tree is not open yet, I will announce when it is and you can submit
> net-next targetted patches.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
