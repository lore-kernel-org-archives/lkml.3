Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaHKTqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:46:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58468 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaHKTqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:46:22 -0400
Date: Mon, 11 Aug 2014 12:46:21 -0700 (PDT)
Message-Id: <20140811.124621.576073630604147753.davem@davemloft.net>
To: mst@redhat.com
Cc: razya@il.ibm.com, kvm@vger.kernel.org, GLIKSON@il.ibm.com,
        ERANRA@il.ibm.com, YOSSIKU@il.ibm.com, JOELN@il.ibm.com,
        abel.gordon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost: Add polling mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140810194559.GA4344@redhat.com>
References: <1407659404-razya@il.ibm.com>
	<20140810083035.0CF58380729@moren.haifa.ibm.com>
	<20140810194559.GA4344@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 12:46:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 10 Aug 2014 21:45:59 +0200

> On Sun, Aug 10, 2014 at 11:30:35AM +0300, Razya Ladelsky wrote:
 ...
> And, did your tests actually produce 100% load on both host CPUs?
 ...

Michael, please do not quote an entire patch just to ask a one line
question.

I truly, truly, wish it was simpler in modern email clients to delete
the unrelated quoted material because I bet when people do this they
are simply being lazy.

Thank you.
