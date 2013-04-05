Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161629Ab3DEIYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:24:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55089 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3DEIYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:24:31 -0400
Date: Fri, 05 Apr 2013 04:24:27 -0400 (EDT)
Message-Id: <20130405.042427.456273365605730206.davem@davemloft.net>
To: ivecera@redhat.com
Cc: craig.hada@hp.com, netdev@vger.kernel.org, sathya.perla@emulex.com,
        subbu.seetharaman@emulex.com, ajit.khaparde@emulex.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] drivers/net: Enable IOMMU pass through for
 be2net
From: David Miller <davem@davemloft.net>
In-Reply-To: <515E827C.3070702@redhat.com>
References: <1358562195-2028-1-git-send-email-craig.hada@hp.com>
	<1358562195-2028-2-git-send-email-craig.hada@hp.com>
	<515E827C.3070702@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 05 Apr 2013 01:24:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Fri, 05 Apr 2013 09:51:24 +0200

> Dave, I'd like to ask when do you plan to apply this patch?

I'm waiting for the be2net driver maintainers to integrate it and
resend it to me, they're usually very good about that.
