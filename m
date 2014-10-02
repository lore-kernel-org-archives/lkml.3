Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaJBGUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 02:20:51 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51946 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaJBGUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 02:20:50 -0400
Date: Wed, 1 Oct 2014 23:20:46 -0700
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Amber Thrall <amber.rose.thrall@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed all coding style issues for
 drivers/staging/media/lirc/
Message-ID: <20141002062046.GA1558@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Amber Thrall <amber.rose.thrall@gmail.com>,
	linux-kernel@vger.kernel.org
References: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amber,

On Wed, Oct 01, 2014 at 09:40:02PM -0700, Amber Thrall wrote:
> Fixed various coding style issues, including strings over 80 characters long and many 

Log messages are easier to read if they are less than 80 characters wide too.

I like to use a width of 72 characters.  It allows enough room for a few
replies without wrapping.

> deprecated printk's have been replaced with proper methods.
> 
> Signed-off-by: Amber Thrall <amber.rose.thrall@gmail.com>
> ---
...

-- 
Jeremiah Mahler
jmmahler@gmail.com
http://github.com/jmahler
