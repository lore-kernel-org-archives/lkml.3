Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab3CGQ5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:57:33 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42323 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3CGQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:57:32 -0500
Message-ID: <1362675448.15793.216.camel@edumazet-glaptop>
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 08:57:28 -0800
In-Reply-To: <20130307163743.GC6115@beaver>
References: <20130209141029.GA13493@beaver>
	 <1360422473.6696.28.camel@edumazet-glaptop> <20130307125424.GI13493@beaver>
	 <1362673223.15793.215.camel@edumazet-glaptop>
	 <20130307163743.GC6115@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 20:37 +0400, Alexey Vlasov wrote:
> On Thu, Mar 07, 2013 at 08:20:23AM -0800, Eric Dumazet wrote:
> >
> > What are gr_xxxx symbols ?
> 
> This is grsecurity patches ;)
>  

Well, remove all alien patches and try to reproduce the bug with a
pristine linux kernel.



