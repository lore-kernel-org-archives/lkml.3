Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaLQJB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:01:56 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:42918 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaLQJBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:01:54 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2014 04:01:54 EST
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Joe Perches <joe@perches.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1418761033.14140.5.camel@perches.com>
References: <1418761033.14140.5.camel@perches.com>
Subject: Re: [PATCH netfilter-next] xt_osf: Use continue to reduce indentation
MIME-Version: 1.0
Message-Id: <8632531418806285@web23h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 17 Dec 2014 11:51:25 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

16.12.2014, 23:17, "Joe Perches" <joe@perches.com>:
> Invert logic in test to use continue.
>
> This routine already uses continue, use it a bit more to
> minimize > 80 column long lines and unnecessary indentation.
>
> No change in compiled object file.

Looks good. Thank you.
Which tree should this patch go through? Please pull it in.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
