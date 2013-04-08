Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3DHFyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 01:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab3DHFyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 01:54:12 -0400
Date: Mon, 8 Apr 2013 11:23:54 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: arnd@arndb.de, rusty@rustcorp.com.au, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] virtio_console: make local symbols static
Message-ID: <20130408055354.GC16207@amit.redhat.com>
References: <CAPgLHd8ffGFuLdAFnx=bDmBS5U0FrH-fqCeneOHeWQQSE+v4wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8ffGFuLdAFnx=bDmBS5U0FrH-fqCeneOHeWQQSE+v4wg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Sat) 06 Apr 2013 [11:52:07], Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Those symbols only used within this file, and should be static.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Amit Shah <amit.shah@redhat.com>

		Amit
