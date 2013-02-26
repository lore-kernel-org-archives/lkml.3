Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab3BZAch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:32:37 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62126 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3BZAcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:32:36 -0500
Date: Mon, 25 Feb 2013 16:32:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] devres: allow adding custom actions to the stack
Message-ID: <20130226003232.GA20902@kroah.com>
References: <20130224040556.GA15339@core.coreip.homeip.net>
 <20130225234801.GD2679@htj.dyndns.org>
 <20130226001150.GC13272@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226001150.GC13272@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:11:51PM -0800, Dmitry Torokhov wrote:
> On Mon, Feb 25, 2013 at 03:48:01PM -0800, Tejun Heo wrote:
> > On Sat, Feb 23, 2013 at 08:05:57PM -0800, Dmitry Torokhov wrote:
> > > Sometimes drivers need to execute one-off actions in their error handling
> > > or device teardown paths. An example would be toggling a GPIO line to
> > > reset the controlled device into predefined state.
> > > 
> > > To allow performing such actions when using managed resources let's allow
> > > adding them to stack/group of devres resources.
> > > 
> > > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > Acked-by: Tejun Heo <tj@kernel.org>
> > 
> 
> Thanks Tejun.
> 
> Greg, if possible I'd like to carry this in my tree as I have driver
> changes depending on this.

No objection from me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
