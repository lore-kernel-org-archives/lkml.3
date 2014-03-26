Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaCZKez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:34:55 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:53784 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaCZKex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:34:53 -0400
MIME-Version: 1.0
In-Reply-To: <1395828547.22808.28.camel@kazak.uk.xensource.com>
References: <1395806210-23528-1-git-send-email-sj38.park@gmail.com> <1395828547.22808.28.camel@kazak.uk.xensource.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 26 Mar 2014 19:34:21 +0900
Message-ID: <CAEjAshoYWeCdVD9mC4f6EQkQkd-dVuk47gGEZ-4ig-uVS938ag@mail.gmail.com>
Subject: Re: [PATCH] ixen-netback: fix trivial printf format build warning
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: trivial@kernel.org, wei.liu2@citrix.com, xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for let me know kindly :)

On Wed, Mar 26, 2014 at 7:09 PM, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> On Wed, 2014-03-26 at 12:56 +0900, SeongJae Park wrote:
>> Fix following trivial build warning:
>>
>> drivers/net/xen-netback/netback.c: In function ‘xenvif_tx_dealloc_action’:
>> drivers/net/xen-netback/netback.c:1585:8: warning:
>> format ‘%x’ expects argument of type
>>  ‘unsigned int’, but argument 3 has type ‘long int’ [-Wformat=]
>>         gop - vif->tx_unmap_ops, ret);
>>         ^
>>
>> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>
> Thanks but davem indicated overnight that he has already pushed a
> suitable fix to net-next.
>
> Ian.
>
>
