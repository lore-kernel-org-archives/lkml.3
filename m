Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3LEA45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:56:57 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:45728 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3LEA4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:56:55 -0500
Date: Wed, 4 Dec 2013 16:56:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Michal Hocko <mhocko@suse.cz>, William Dauchy <wdauchy@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Ma, Xindong" <xindong.ma@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, azurIt <azurit@pobox.sk>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] Fix race between oom kill and task exit
In-Reply-To: <20131202141203.GA31402@redhat.com>
Message-ID: <alpine.DEB.2.02.1312041655370.13608@chino.kir.corp.google.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com> <20131128063505.GN3556@cmpxchg.org> <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com> <20131128120018.GL2761@dhcp22.suse.cz> <20131128183830.GD20740@redhat.com>
 <20131202141203.GA31402@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Oleg Nesterov wrote:

> OK, I am going to send the initial fixes today. This means (I hope)
> that we do not need this or Sameer's "[PATCH] mm, oom: Fix race when
> selecting process to kill".
> 

Your v2 series looks good and I suspect anybody trying them doesn't have 
additional reports of the infinite loop?  Should they be marked for 
stable?
