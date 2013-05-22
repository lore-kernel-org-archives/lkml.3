Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3EVPSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:18:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35920 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054Ab3EVPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:18:50 -0400
X-Sasl-enc: O79uV/Ui9oYWQ9sj/fom0eJufSrgKV/ivdBWljSrqAKa 1369235927
Date: Wed, 22 May 2013 08:18:46 -0700
From: Greg KH <greg@kroah.com>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Updated broken link in HOWTO
Message-ID: <20130522151846.GA10049@kroah.com>
References: <1369212127-9199-1-git-send-email-PuZZleDucK@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369212127-9199-1-git-send-email-PuZZleDucK@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 06:42:07PM +1000, Ben Minerds wrote:
> Updated broken "The Perfect Patch" link in HOWTO to a copy at kerneltrap.org.
> 
> Signed-off-by: Ben Minerds <puzzleduck@gmail.com>

That's fine, but how about we put that document into the Documentation
directory?  That would make it easier to point people to, and we
wouldn't rely on random web servers to stay alive.

thanks,

greg k-h
