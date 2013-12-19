Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab3LSMcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:32:17 -0500
Received: from doppler.thel33t.co.uk ([193.110.88.198]:42286 "EHLO
	doppler.thel33t.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3LSMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:32:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 19 Dec 2013 12:39:22 +0000
From: Leigh Brown <leigh@solinno.co.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: mvmdio: fix interrupt timeout handling
In-Reply-To: <52B2D97F.4070200@gmail.com>
References: <1387451589-15491-1-git-send-email-leigh@solinno.co.uk>
 <52B2D97F.4070200@gmail.com>
Message-ID: <a1205db8e38fbdc0cf64f235de54cc67@doppler.thel33t.co.uk>
User-Agent: Roundcube Webmail/0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-19 11:33, Sebastian Hesselbarth wrote:
>> +			 if (timeout < 2)
>> +			 	timeout = 2;
> 
> Hi Leigh,
> 
> above two lines have a whitespace issue.

Crap, you are correct.  I will fix it and send another patch.

Regards,

Leigh.

