Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3BMHjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:39:01 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:36870 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab3BMHi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:38:59 -0500
Message-ID: <511B4311.3090801@msgid.tls.msk.ru>
Date: Wed, 13 Feb 2013 11:38:57 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org
Subject: Re: [PATCH linux-next] autofs4: autofs4_catatonic_mode(): remove
 redundant null check on kfree()
References: <1360689138-59191-1-git-send-email-tim.gardner@canonical.com>  <1360740008.2288.3.camel@perseus.themaw.net>  <511B3F5B.4050803@msgid.tls.msk.ru> <1360741066.2288.7.camel@perseus.themaw.net>
In-Reply-To: <1360741066.2288.7.camel@perseus.themaw.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13.02.2013 11:37, Ian Kent wrote:
[]
> So, you would like me to forward this to Linus?
>
> I'd be inclined to wait until the window for 3.9 opens since Linus
> probably has more than enough to do finalizing 3.8 right now.

I guess this change is anything but urgent ;)

Thanks,

/mjt
