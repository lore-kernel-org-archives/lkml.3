Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3CLXXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:23:37 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46474 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3CLXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:23:35 -0400
Date: Tue, 12 Mar 2013 16:23:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>,
        Matt Ranostay <mranostay@gmail.com>, panto@antoniou-consulting.com,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 3/5] W1: w1-gpio - guard DT IDs with CONFIG_OF
Message-ID: <20130312232332.GA29038@kroah.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
 <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
 <1361775577-4578-3-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361775577-4578-3-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 10:59:35PM -0800, Dmitry Torokhov wrote:
> This fixes the following warning:
> 
>   CC      drivers/w1/masters/w1-gpio.o
> drivers/w1/masters/w1-gpio.c:50:28: warning: ‘w1_gpio_dt_ids’ defined but not used [-Wunused-variable]
> 
> Also provide stub for w1_gpio_probe_dt() if device tree support is
> disabled.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/w1/masters/w1-gpio.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Already fixed.
