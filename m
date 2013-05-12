Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3ELWNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 18:13:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:36780 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3ELWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 18:13:50 -0400
Message-ID: <519013F3.5@infradead.org>
Date: Sun, 12 May 2013 15:13:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.10-rc1
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/13 12:30, Geert Uytterhoeven wrote:
> 
> 
> *** WARNINGS ***
> 
> 163 regressions:
>   + mm/slab_common.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 303:6


How does this happen?  'size' is clearly a size_t in this function so "%zu" is correct.

Does some arch (or gcc) confuse these?

-- 
~Randy
