Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3IXTVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:21:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48704 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3IXTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:21:05 -0400
Date: Tue, 24 Sep 2013 12:21:01 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Vincent Li <vincent.mc.li@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] Allow userspace code to use flag IFA_F_SECONDARY to
 specify an ip address to be primary or secondary ip on an interface
Message-ID: <20130924122101.6912dde0@nehalam.linuxnetplumber.net>
In-Reply-To: <1380046281-6012-1-git-send-email-vincent.mc.li@gmail.com>
References: <1380046281-6012-1-git-send-email-vincent.mc.li@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013 11:11:21 -0700
Vincent Li <vincent.mc.li@gmail.com> wrote:

> -	ifa->ifa_flags &= ~IFA_F_SECONDARY;
>  	last_primary = &in_dev->ifa_list;
>  
> +	if((*last_primary) == NULL)


Minor nit, paren's here are unnecessary
