Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab3BYXsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:48:15 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:59557 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3BYXsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:48:06 -0500
Date: Mon, 25 Feb 2013 15:48:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] devres: allow adding custom actions to the stack
Message-ID: <20130225234801.GD2679@htj.dyndns.org>
References: <20130224040556.GA15339@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130224040556.GA15339@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 08:05:57PM -0800, Dmitry Torokhov wrote:
> Sometimes drivers need to execute one-off actions in their error handling
> or device teardown paths. An example would be toggling a GPIO line to
> reset the controlled device into predefined state.
> 
> To allow performing such actions when using managed resources let's allow
> adding them to stack/group of devres resources.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
