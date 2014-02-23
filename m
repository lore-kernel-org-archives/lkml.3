Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaBWC0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 21:26:41 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49389 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBWC0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 21:26:40 -0500
Date: Sat, 22 Feb 2014 18:26:37 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        Josh Wu <josh.wu@atmel.com>, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com
Subject: Re: [PATCH] MTD: atmel_nand: POI fall back is not an issue: change
 log level
Message-ID: <20140223022637.GD11836@norris-Latitude-E6410>
References: <1392204414-20700-1-git-send-email-nicolas.ferre@atmel.com>
 <20140212114200.GA11498@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212114200.GA11498@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:42:00PM +0100, Alexandre Belloni wrote:
> Small nitpick, subject should read PIO, not POI.

Amended the commit message and pushed to l2-mtd.git. Thanks!

Brian
