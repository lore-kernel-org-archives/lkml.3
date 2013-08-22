Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3HVGCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:02:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45126 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3HVGCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:02:07 -0400
Date: Wed, 21 Aug 2013 23:02:15 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
Message-ID: <20130822060215.GB14935@kmo-pixel>
References: <520C788A.1060208@profihost.ag>
 <520DFAB4.1050402@profihost.ag>
 <52114614.4070509@profihost.ag>
 <20130819222718.GA32104@kmo-pixel>
 <52132243.8050803@profihost.ag>
 <521323D1.1070503@profihost.ag>
 <20130821234715.GA4630@moria.home.lan>
 <5215A130.9080508@profihost.ag>
 <20130822054336.GA14935@kmo-pixel>
 <5215A8A8.90900@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215A8A8.90900@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 07:59:04AM +0200, Stefan Priebe wrote:
> 
> >schedule_timeout() is not the same as
> >schedule_timeout_interruptible().
> 
> just search and replace? So i can try on my own.

The one in read_dirty(), line ~330
