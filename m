Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3HVHmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:42:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51765 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3HVHmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:42:45 -0400
Date: Thu, 22 Aug 2013 00:42:54 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
Message-ID: <20130822074253.GD14935@kmo-pixel>
References: <52114614.4070509@profihost.ag>
 <20130819222718.GA32104@kmo-pixel>
 <52132243.8050803@profihost.ag>
 <521323D1.1070503@profihost.ag>
 <20130821234715.GA4630@moria.home.lan>
 <5215A130.9080508@profihost.ag>
 <20130822054336.GA14935@kmo-pixel>
 <5215A8A8.90900@profihost.ag>
 <20130822060215.GB14935@kmo-pixel>
 <5215BEA4.6040101@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215BEA4.6040101@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 09:32:52AM +0200, Stefan Priebe - Profihost AG wrote:
> great!
> 
> Everything seems to work fine now! Except read_dirty always going to
> negative values after a reboot.

That one's fixed in 3.11 :)
