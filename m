Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3HZK5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:57:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3HZK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:57:14 -0400
Date: Mon, 26 Aug 2013 03:59:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.10.9 Crash
Message-ID: <20130826105930.GA25331@kroah.com>
References: <1681718.fu8vXZyU0z@calvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1681718.fu8vXZyU0z@calvin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 10:36:30AM +0200, Fabio Coatti wrote:
> Hi all, 
> I'm remotely managing a 3.10.9 server and this morning I found it locked.
> The only data I could gather is a screenshot (thru AMT interface).
> I've ran it thru gocr and this is the result (some char got garbled but the 
> bulk is ok).
> The machine is pretty new and stable, nothin like this happened with previous 
> 3.10.X

Can you reproduce this easily?  If so, can you use 'git bisect' to track
down the offending patch?

thanks,

greg k-h
