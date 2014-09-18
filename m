Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaIRGdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:33:31 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56209 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaIRGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:33:30 -0400
Date: Wed, 17 Sep 2014 23:33:26 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: denali: fix include guard and license block of
 denali.h
Message-ID: <20140918063326.GL7362@norris-Latitude-E6410>
References: <1409310051-25726-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409310051-25726-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 08:00:51PM +0900, Masahiro Yamada wrote:
> It looks like this header file is a concatenation of two headers.
> Anyway, the include guard should be renamed and placed at the correct
> postion and the license block in the middle should be deleted.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Pushed to l2-mtd.git. Thanks!

Brian
