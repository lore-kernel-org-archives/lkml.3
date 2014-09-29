Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaI2SjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:39:06 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55384 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaI2SjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:39:04 -0400
Date: Mon, 29 Sep 2014 13:38:56 -0500
From: Michael Welling <mwelling@ieee.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        pmeerw@pmeerw.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20140929183856.GA11871@sysresccd>
References: <20140916170316.GD19010@saruman.home>
 <20140917150041.GA6903@saruman.home>
 <20140918133631.GA24847@saruman.home>
 <20140919162129.GE26946@saruman.home>
 <20140922140914.GC25620@saruman>
 <20140923140924.GA28592@saruman>
 <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
 <20140929140227.GD32403@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929140227.GD32403@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 09:02:27AM -0500, Felipe Balbi wrote:
> Alright, this is already ridiculous. Andrew, if I resend the patch can
> you apply it since maintainer has been ignoring this thread anyway ?
> 

Do you reall think this is the best way to approach this?

Perhaps it would be better to explain what each field of the
configuration register does and then we can move on.

In particular the OPT3001_CONFIGURATION_L field needs to be explained
such that the ABI can be properly applied.

Looking at the docs for the Windows demo program the field is associated
with a latch configuration. What does this bit field actually do?

Either have TI release the documentation or add comments to each of the
fields of each of the registers such that we can understand what exactly
they are doing.

