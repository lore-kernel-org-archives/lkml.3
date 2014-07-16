Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaGPCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:16:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaGPCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:16:55 -0400
Date: Tue, 15 Jul 2014 19:21:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stone Kang <stonekyx@gmail.com>
Cc: devel@driverdev.osuosl.org, Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm+renesas@opensource.se>,
        Sachin Kamat <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: emxx_udc: Fix coding style errors
Message-ID: <20140716022128.GA22440@kroah.com>
References: <1405473375-29825-1-git-send-email-stonekyx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405473375-29825-1-git-send-email-stonekyx@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:16:15AM +0800, Stone Kang wrote:
> Only fixing errors reported by checkpatch.pl, based on the following
> rules:
> 1. '*' should be adjacent to the data name or function name.
> 2. Don't use C99-style "// ..." comments.
> 
> Signed-off-by: KANG Yuxuan <stonekyx@gmail.com>

I see two different names here, one in the "From:" line, and one in the
Signed-off-by: line, are they the same?  They need to match up :(

Please resend with this fixed.

thanks,

greg k-h
