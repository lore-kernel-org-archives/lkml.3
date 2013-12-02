Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3LBQwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:52:03 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47387 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3LBQwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:52:00 -0500
Message-ID: <1386003115.5352.59.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/4] pch_gbe: Fix transmit queue management
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: David.Laight@ACULAB.COM, puzman@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Dec 2013 08:51:55 -0800
In-Reply-To: <1386001999.5352.51.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1385631882-12827-2-git-send-email-puzman@gmail.com>
	 <20131129.164229.2292905485668904870.davem@davemloft.net>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B744F@saturn3.aculab.com>
	 <20131202.111600.1622488165507147936.davem@davemloft.net>
	 <1386001999.5352.51.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 08:33 -0800, Eric Dumazet wrote:

> So far, only virtual drivers and 2 or 3 others advertise
> NETIF_F_FRAGLIST 'support'.
> 
> I suspect that the '2 or 3 others' are plain bugs, I'll check this.
> 

Yep, these all are plain bugs, I submitted a fix.



