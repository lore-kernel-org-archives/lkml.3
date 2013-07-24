Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314Ab3GXAFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:05:16 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51247 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3GXAFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:05:13 -0400
Message-ID: <1374624310.3449.53.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, oliver@neukum.org, grundler@google.com,
        freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Date: Tue, 23 Jul 2013 17:05:10 -0700
In-Reply-To: <1374623813.3449.52.camel@edumazet-glaptop>
References: <1374518841.4990.26.camel@edumazet-glaptop>
	 <1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
	 <1374559827.4990.143.camel@edumazet-glaptop>
	 <20130723.164656.1794159338719943519.davem@davemloft.net>
	 <1374623813.3449.52.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 16:56 -0700, Eric Dumazet wrote:

> > A quick scan shows that smsc75xx, smsc95xx, and ax88179_178a all have
> > this problem.
> > 
> > Instead of the patch starting this thread, I'd like to see one that
> > hits all three drivers and removes all SG and TSO features bits from
> > both the ->features _and_ ->hw_features settings.
> > 
> > Could someone toss that together quickly?
> 
> Yes, I can prepare this patch.

Looks like only ax88179_178a & smsc75xx are impacted.


