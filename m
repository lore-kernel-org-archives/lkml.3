Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbbAMKdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:33:09 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57593 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbbAMKdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:33:08 -0500
Date: Tue, 13 Jan 2015 02:33:03 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: dinguyen@opensource.altera.com
Cc: dwmw2@infradead.org, dinh.linux@gmail.com, yamada.m@jp.panasonic.com,
        josh@joshtriplett.org, shijie8@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Graham Moore <grmoore@opensource.altera.com>
Subject: Re: [PATCH] mtd: denali: fix incorrect bitmask error in
 denali_setup_dma
Message-ID: <20150113103303.GB13943@norris-Latitude-E6410>
References: <1420817555-22828-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420817555-22828-1-git-send-email-dinguyen@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 09:32:35AM -0600, dinguyen@opensource.altera.com wrote:
> From: Graham Moore <grmoore@opensource.altera.com>
> 
> commit "3157d1ed2309 mtd: denali: remove unnecessary casts" introduced
> an error by using a wrong bitmask.
> 
> A uint16_t cast was replaced with & 0xff, should be & 0xffff.
> 
> Signed-off-by: Graham Moore <grmoore@opensource.altera.com>
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>

Pushed to l2-mtd.git. Thanks!

Brian
