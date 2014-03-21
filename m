Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbaCUP6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:58:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57585 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760842AbaCUP6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:58:45 -0400
Date: Fri, 21 Mar 2014 16:58:42 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 1/5] clk: berlin: add support for berlin plls
Message-ID: <20140321155842.GG6443@piout.net>
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395402220-23503-2-git-send-email-alexandre.belloni@free-electrons.com>
 <532C355C.3090606@gmail.com>
 <20140321154539.GD6443@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321154539.GD6443@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2014 at 16:45:39 +0100, Alexandre Belloni wrote :
> > >+	.fbdiv_shift = 6,
> > >+	.rfdiv_shift = 1,
> > >+	.divsel_shift = 7,
> > 
> > Have .foo_mask and .foo_shift together?
> > 
> 
> This will make the struct larger but I don't really have an opinion.
> 

Forget that one, I'll take a break...

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
