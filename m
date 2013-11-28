Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3K1Su3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:50:29 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:44798 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3K1Su2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:50:28 -0500
Date: Thu, 28 Nov 2013 19:50:27 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Kamala R <kamala@aristanetworks.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] IPv6: Fixed support for blackhole and prohibit routes
Message-ID: <20131128185027.GC24171@order.stressinduktion.org>
Mail-Followup-To: Kamala R <kamala@aristanetworks.com>,
	netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
References: <1385108488-32163-1-git-send-email-kamala@aristanetwors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385108488-32163-1-git-send-email-kamala@aristanetwors.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 01:51:28PM +0530, Kamala R wrote:
> From: Kamala R <kamala@aristanetworks.com>
> 
> The behaviour of blackhole and prohibit routes has been corrected by setting
> the input and output function pointers of the dst variable appropriately. For
> blackhole routes, they are set to dst_discard and to ip6_pkt_prohibit and
> ip6_pkt_prohbit_out respectively for prohibit routes.
> 
> Changes from v1: Logic is the same. Changes made for readability and so it
> looks pleasing.

David, fyi a third version of this patch has been posted.

