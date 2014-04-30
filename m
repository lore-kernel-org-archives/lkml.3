Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbaD3QGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:06:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41105 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885AbaD3QGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:06:54 -0400
Date: Wed, 30 Apr 2014 12:06:49 -0400 (EDT)
Message-Id: <20140430.120649.2287464187870126146.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on
 the send path
From: David Miller <davem@davemloft.net>
In-Reply-To: <7a7fd7286bc44121839ec68c8d1458b2@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1398288285-16268-1-git-send-email-kys@microsoft.com>
	<7a7fd7286bc44121839ec68c8d1458b2@BY2PR03MB299.namprd03.prod.outlook.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Apr 2014 09:06:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KY Srinivasan <kys@microsoft.com>
Date: Wed, 30 Apr 2014 14:17:04 +0000

> Please let me know if there is some other issue you want addressed in this patch.

If the patch isn't in patchwork, I'm not going to apply it and you need to
simply resubmit it.
