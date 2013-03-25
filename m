Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3CYDWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:22:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8947 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab3CYDWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:22:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,342,1363104000"; 
   d="scan'208";a="6935788"
Message-ID: <514FC385.4030008@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 11:24:53 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lenky Gao <lenky.gao@gmail.com>
CC: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Subject: Re: Question: How to distribute the interrupts over multiple cores?
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com> <514FBD6E.2030706@cn.fujitsu.com> <CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com>
In-Reply-To: <CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 11:21:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 11:22:00,
	Serialize complete at 2013/03/25 11:22:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/25/2013 11:18 AM, Lenky Gao wrote:
> The irqbalance service has been stopped.
So try start irqbalance to see what happen?
It should help to give what you want ;-)

thanks,
linfeng
