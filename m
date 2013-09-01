Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab3IASff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 14:35:35 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:59528 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3IASfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 14:35:34 -0400
Date: Sun, 1 Sep 2013 20:35:33 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: ipv6_create_tempaddr cleanup
Message-ID: <20130901183533.GB19455@order.stressinduktion.org>
Mail-Followup-To: Petr Holasek <pholasek@redhat.com>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1377874958-2426-1-git-send-email-pholasek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1377874958-2426-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 05:02:38PM +0200, Petr Holasek wrote:
> This two-liner removes max_addresses variable which is now unecessary related
> to patch [ipv6: remove max_addresses check from ipv6_create_tempaddr].
> 
> Signed-off-by: Petr Holasek <pholasek@redhat.com>

Uh, yes, I missed that. Thanks a lot!

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

