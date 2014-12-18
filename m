Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaLRC5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:57:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLRC5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:57:17 -0500
Date: Wed, 17 Dec 2014 18:57:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frederic Jacob <frederic.jacob.78@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix blank line coding style in
 comedi_bond.c
Message-ID: <20141218025716.GA9737@kroah.com>
References: <1418870141-10323-1-git-send-email-frederic.jacob.78@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418870141-10323-1-git-send-email-frederic.jacob.78@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 09:35:41PM -0500, Frederic Jacob wrote:
> This is a patch to the comedi_bond.c file that fixes up a blank line after declaration warning found by the checkpatch.pl tool

Please line-wrap your line properly.


> Signed-off-by: Frederic Jacob <frederic.jacob.78@gmail.com>

And provide an empty line before the signed-off-by: line.

Can you fix that up and resend?

thanks,

greg k-h
