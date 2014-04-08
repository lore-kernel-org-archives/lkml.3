Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaDHEvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 00:51:48 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37845 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaDHEvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 00:51:47 -0400
Message-ID: <1396932704.16584.9.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] decnet: fix possible NULL deref in dnet_select_source()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sasha.levin@oracle.com, netdev@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davej@redhat.com
Date: Mon, 07 Apr 2014 21:51:44 -0700
In-Reply-To: <20140407.151854.411047851818388937.davem@davemloft.net>
References: <5341A3C1.9060101@oracle.com>
	 <1396821554.12330.51.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140407.151854.411047851818388937.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 15:18 -0400, David Miller wrote:

> And in the loopback case, it is the decnet stack's responsibility to
> make sure ->dn_ptr is setup properly, else it should fail the module
> load and stack initialization.
> can fix this properly.

This was based on Sasha report and my limited time.
It seems you have more time than me to spend on decnet !



