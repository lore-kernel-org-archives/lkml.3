Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3K0LxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:53:12 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:46347 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3K0LxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131127115052.GX29824@moon>
References: <20131101220634.605745564@linuxfoundation.org> <20131101220649.696585269@linuxfoundation.org>
 <CAJ75kXa=zh3NBRqR43nRv2s7WToDMNSmARs1PMABOE8-7hksDw@mail.gmail.com> <20131127115052.GX29824@moon>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 27 Nov 2013 12:52:46 +0100
Message-ID: <CAJ75kXZ3n3AAipJ58+7jPqtmW+JHCkXrmAvPPU_i2ZiabzgNvA@mail.gmail.com>
Subject: Re: [PATCH 3.11 54/66] mm: migration: do not lose soft dirty bit if
 page is in migration state
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

On Wed, Nov 27, 2013 at 12:50 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> "Soft dirty bit" feature introduced in 3.11 kernel and as far as I know
> we've no plans to backport it on 3.10 series.

ok thanks for the information and the quick reply.

-- 
William
