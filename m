Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045Ab3HJPcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:32:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48686 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934409Ab3HJPcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:32:19 -0400
Message-ID: <1376148738.2083.17.camel@joe-AO722>
Subject: Re: [PATCH] arch/arm/mach-pxa/stargate2.c: use ARRAY_AND_SIZE
 consistently
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 10 Aug 2013 08:32:18 -0700
In-Reply-To: <1376148353-9699-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376148353-9699-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-10 at 17:25 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Because ARRAY_AND_SIZE changes the apparent arity of a function, if it is
> used for one call to a given function, it would be better, if possible, to
> use it for all of them.

I think it'd be better to remove ARRAY_AND_SIZE instead.


