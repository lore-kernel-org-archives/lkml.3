Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab3GaIRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:17:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:55102 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3GaIRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:17:12 -0400
Message-ID: <51F8C7F4.9020504@parallels.com>
Date: Wed, 31 Jul 2013 12:16:52 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <luto@amacapital.net>, <gorcunov@openvz.org>, <mpm@selenic.com>,
        <xiaoguangrong@linux.vnet.ibm.com>, <mtosatti@redhat.com>,
        <kosaki.motohiro@gmail.com>, <sfr@canb.auug.org.au>,
        <peterz@infradead.org>, <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [patch 2/2] [PATCH] mm: Save soft-dirty bits on file pages
References: <20130730204154.407090410@gmail.com> <20130730204654.966378702@gmail.com>
In-Reply-To: <20130730204654.966378702@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 12:41 AM, Cyrill Gorcunov wrote:

> Andy reported that if file page get reclaimed we loose soft-dirty bit
> if it was there, so save _PAGE_BIT_SOFT_DIRTY bit when page address
> get encoded into pte entry. Thus when #pf happens on such non-present
> pte we can restore it back.
> 
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
