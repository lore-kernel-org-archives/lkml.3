Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaBNPwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:52:13 -0500
Received: from forward3h.mail.yandex.net ([84.201.187.148]:51131 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBNPwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:52:08 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2014 10:52:08 EST
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Dan Carpenter <dan.carpenter@oracle.com>, David Fries <david@fries.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20140211210755.GA25579@elgon.mountain>
References: <20140211164513.GF5530@spacedout.fries.net> <20140211210755.GA25579@elgon.mountain>
Subject: Re: [patch v2] w1: small type cleanup in sysfs
MIME-Version: 1.0
Message-Id: <85681392392562@web18h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 14 Feb 2014 19:42:42 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

12.02.2014, 01:08, "Dan Carpenter" <dan.carpenter@oracle.com>:
> On 64 bit systems, a large value for "long tmp" is truncated when
> assigning to "int md->max_slave_count" so we still end up with a value
> less than one despite the "tmp < 1" check.
>
> This is more of a problem for static checkers than a real life issue,
> but it's simple enough to fix.
>
> Acked-by: David Fries <david@fries.net>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks good to me, thank you
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
