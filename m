Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3CVPBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:01:09 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62771 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3CVPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:01:07 -0400
Message-ID: <1363964464.4431.67.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: Add support for handling queueing in hardware
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Collins <benmcollins13@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 22 Mar 2013 08:01:04 -0700
In-Reply-To: <63463136-FE5B-462D-9259-53DD5AC61BDB@gmail.com>
References: <E1UJ1fR-0004hs-4l@swissweb.swissdisk.com>
	 <1363962193.4431.59.camel@edumazet-glaptop>
	 <63463136-FE5B-462D-9259-53DD5AC61BDB@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 10:50 -0400, Ben Collins wrote:

> 
>         NETIF_F_LLTX_BIT,               /* LockLess TX - deprecated. Please */
>                                         /* do not use LLTX in new drivers */

Yes, but this is the current way to do that.

Unless you design a complete new layer to replace it.



