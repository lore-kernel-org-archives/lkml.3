Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaKXSf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:35:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51092 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaKXSfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:35:42 -0500
Date: Mon, 24 Nov 2014 13:35:36 -0500 (EST)
Message-Id: <20141124.133536.321713270291979583.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com, rusty@au1.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 00/41] linux: towards virtio-1 guest support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416829787-14252-1-git-send-email-mst@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 10:35:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 24 Nov 2014 13:52:32 +0200

> Based on patches by Cornelia Rusty and others, but
> with an API that should allow better static checking of code,
> and slightly more concervative changes in vring,net and blk.
> 
> Based on patches by Cornelia and others, but
> with an API that should allow better static checking of code,
> slightly more concervative changes in vring and drivers,

Some cut and paste duplication happening here :)
