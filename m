Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3JVRRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:17:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:54929 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3JVRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:17:35 -0400
Message-ID: <5266B32B.9060605@linutronix.de>
Date: Tue, 22 Oct 2013 19:17:31 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Zubair Lutfullah <zubair.lutfullah@gmail.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com> <20130807084054.GA18668@lee--X1> <52667A6C.6000301@linutronix.de> <20131022160523.GB24024@lee--X1> <5266AA0F.1030603@linutronix.de> <20131022170621.GB2620@lee--X1>
In-Reply-To: <20131022170621.GB2620@lee--X1>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 07:06 PM, Lee Jones wrote:
> Hmm.. I'm starting to see what you mean.
> 
> So what's the point of the read before write then?
> 
> Why don't you use the cache all of the time?

I'm waiting for Zabair for this. The last thing he said is that he is
going to have a wedding which might involve some off time but then this
was on the 7th this month.
Depending how long it takes I start digging myself after I finish some
other things.

Sebastian
