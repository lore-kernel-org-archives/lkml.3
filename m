Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbaKTIR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:17:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58176 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaKTIR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:17:27 -0500
Date: Thu, 20 Nov 2014 08:17:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eli Cohen <eli@mellanox.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: mlx5: don't duplicate kvfree()
Message-ID: <20141120081726.GK7996@ZenIV.linux.org.uk>
References: <20141120081357.GI7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120081357.GI7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 08:13:57AM +0000, Al Viro wrote:
>  9 files changed, 21 insertions(+), 35 deletions(-)

grr... 8 files changed, actually - that was from the diff that included mlx4
bits.  Patch split correctly and sent in two pieces, summary left as is ;-/
Sorry about the confusion it might cause...
