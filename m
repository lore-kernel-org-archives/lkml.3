Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab3HSU0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:26:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3HSU0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:26:50 -0400
Message-ID: <52127F85.4040403@suse.cz>
Date: Mon, 19 Aug 2013 22:26:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: howto make define seen in all files?
References: <201308180556.45833.lkml@tigusoft.pl>
In-Reply-To: <201308180556.45833.lkml@tigusoft.pl>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 18.8.2013 05:56, lkml@tigusoft.pl napsal(a):
> Hi, I want to provide a general defined macro like __MY__TIME__ (for 
> determinictic build) and that symbol should be seen as #define or -D... to gcc 
> in all files;
> 
> Value of __MY_TIME__ is determined once, at start of build.
> 
> I was using file scripts/mkcompile_h as in the attached .diff patch, worked in 
> 3.2.48 but in 3.2.50 files do not see the value _MY_BUILD__TIME__

Just drop the remaining occurrences of __TIME__ and __DATA__, it's not
worth the hassle to define new macros.

Michal

