Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3JYXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:25:56 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63947 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3JYXZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:25:55 -0400
Date: Fri, 25 Oct 2013 16:25:52 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] bq2415x_charger: fix max battery regulation voltage
Message-ID: <20131025232552.GA13859@teo>
References: <1381932511-31719-1-git-send-email-alexandre.belloni@free-electrons.com>
 <525E9E24.3090401@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <525E9E24.3090401@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 04:09:40PM +0200, Alexandre Belloni wrote:
> I forgot to add this is a v2 and I just added a comment.
> 
> On 16/10/2013 16:08, Alexandre Belloni wrote:
> > As per the datasheets, maximum battery regulation voltage is 4440mV.
> >
> > The formula is (voltage - offset) / step, so the maximum value is:
> > (4440 - 3500) / 20 = 47
> >
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied, thanks!

Anton
