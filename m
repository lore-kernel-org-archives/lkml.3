Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935250Ab3IDP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:57:51 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58439 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929Ab3IDP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:57:50 -0400
Date: Wed, 4 Sep 2013 17:57:38 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Subject: Re: [PATCH net-next 2/2] tuntap: orphan frags before trying to set
 tx timestamp
Message-ID: <20130904155738.GC4194@netboy>
References: <1378269226-5969-1-git-send-email-jasowang@redhat.com>
 <1378269226-5969-2-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378269226-5969-2-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:33:46PM +0800, Jason Wang wrote:
> sock_tx_timestamp() will clear all zerocopy flags of skb which may lead the
> frags never to be orphaned. This will break guest to guest traffic when zerocopy
> is enabled. Fix this by orphaning the frags before trying to set tx time stamp.
> 
> The issue were introduced by commit eda297729171fe16bf34fe5b0419dfb69060f623
> (tun: Support software transmit time stamping).
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
