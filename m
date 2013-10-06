Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab3JFQtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 12:49:39 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50988 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3JFQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 12:49:38 -0400
Date: Sun, 6 Oct 2013 18:49:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131006164934.GA15167@gmail.com>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380922788-23112-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> As suggested by Ingo.
> 
> Make HW_BREAKPOINTS a config option. HW_BREAKPOINTS depends
> on perf. This allows disabling PERF_EVENTS for systems that
> don't need it (e.g. anything not used for development)
> 
> Disabling PERF_EVENTS saves over 700k of kernel text (~5% of my config)
> and significant data/bss:
> 
>    text	   data	    bss	    dec	    hex	filename
> 13692640	1922416	1478656	17093712	104d450	obj/vmlinux
> 12980092	1787544	1470464	16238100	 f7c614	obj-noperf/vmlinux

Btw., could you send me your .config so I can investigate this?

Thanks,

	Ingo
