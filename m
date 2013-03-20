Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3CTQPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:15:51 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45493 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3CTQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:15:49 -0400
Date: Wed, 20 Mar 2013 09:17:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergio Callegari <sergio.callegari@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel panic on stable kernel 3.8.2 when closing bluetooth dun
 connection
Message-ID: <20130320161712.GA27840@kroah.com>
References: <51498CFE.9060804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51498CFE.9060804@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:18:38AM +0100, Sergio Callegari wrote:
> Hi,
> 
> This is just a short note to let you know that 3.8.2 panics on
> closing a bluetooth dun connection.

Have you notified the linux bluetooth developers about this?  Is this
new in 3.8.2 and 3.8.1 or 3.8 works fine?

thanks,

greg k-h
