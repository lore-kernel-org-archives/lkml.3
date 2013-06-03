Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3FCJYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:24:45 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40741 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3FCJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:24:43 -0400
X-Spam-Score: -100.8
Message-ID: <51AC60AA.8010107@asianux.com>
Date: Mon, 03 Jun 2013 17:23:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: edumazet@google.com, Pravin Shelar <pshelar@nicira.com>, mgorman@suse.de,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] include/linux/skbuff.h: using '0xffff' instead of '~0U'
References: <51A6EBC5.7040601@asianux.com> <CAHp75VfWvXkaoYQ_40idSsLYUA=YqaswnV2y-hODHjt7JMHQvQ@mail.gmail.com>
In-Reply-To: <CAHp75VfWvXkaoYQ_40idSsLYUA=YqaswnV2y-hODHjt7JMHQvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 05:05 AM, Andy Shevchenko wrote:
> On Thu, May 30, 2013 at 9:03 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> >
>> > Both 'transport_header' and 'mac_header' are u16, which are never equal
>> > to '~0U'.
>> >
>> > So need use '0xffff' instead of '~0U'.
> Why not "(u16)~0" ?
> Or even better "!= USHORT_MAX"?
> 
> Or mac_header + 1 == 0, though it less clear.

It seems they are just the same as '0xffff' (are all 'magic' number).

We'd better to give a meaningful name to it just like Ben said.


Thanks.
-- 
Chen Gang

Asianux Corporation
