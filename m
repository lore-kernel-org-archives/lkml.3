Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3GKSrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:47:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3GKSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:47:50 -0400
Date: Thu, 11 Jul 2013 11:47:49 -0700 (PDT)
Message-Id: <20130711.114749.1349623560206444581.davem@davemloft.net>
To: maarten.lankhorst@canonical.com
Cc: jcliburn@gmail.com, chris.snook@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alx: fix lockdep annotation
From: David Miller <davem@davemloft.net>
In-Reply-To: <51DEB8D1.6080700@canonical.com>
References: <51DEB8D1.6080700@canonical.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date: Thu, 11 Jul 2013 15:53:21 +0200

> Move spin_lock_init to be called before the spinlocks are used, preventing a lockdep splat.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Looks good, applied, thanks.
