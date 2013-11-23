Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3KWRVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 12:21:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3KWRVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 12:21:23 -0500
Date: Sat, 23 Nov 2013 09:22:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: Adding support to 16-bit regs and 8-bits regs
Message-ID: <20131123172201.GA8405@kroah.com>
References: <20131123144520.D0E08432AB@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123144520.D0E08432AB@localhost.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 03:45:20PM +0100, Christophe Leroy wrote:
> Many components still have 16 bits registers and several even have
> 8 bits registers. This patch adds structures and functions to deal with
> those registers.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

What code is going to call these functions?  I don't want to add apis
with no users, sorry.

thanks,

greg k-h
