Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750Ab3BIPcL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 10:32:11 -0500
Received: from mail.renton.name ([90.155.165.44]:38689 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722Ab3BIPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 10:32:10 -0500
Date: Sat, 9 Feb 2013 19:30:26 +0400
From: Alexey Vlasov <renton@renton.name>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
Message-ID: <20130209153026.GB13493@beaver>
References: <20130209141029.GA13493@beaver>
 <1360422473.6696.28.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360422473.6696.28.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 07:07:53AM -0800, Eric Dumazet wrote:
> Did you compile the kernel yourself, or is it a standard kernel (distro
> provided) ?
> 
> Your traces dont contain symbols, its quite hard to guess the issue.

I compile the kernel myself. Should I add CONFIG_DEBUG_INFO ? ok then
I'll try it. May be I should switch on anything else to get more info
for debug?
Thanks.

-- 
BRGDS. Alexey Vlasov.
