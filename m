Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaL2HCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:02:47 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52579 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaL2HCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:02:46 -0500
Date: Mon, 29 Dec 2014 12:32:39 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jonas Lundqvist <jonas@gannon.se>
Cc: Jeremiah Mahler <jmmahler@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: line6: remove spaces before commas.
Message-ID: <20141229070239.GC3749@sudip-PC>
References: <1419773206-18729-1-git-send-email-jonas@gannon.se>
 <20141228154442.GA24583@hudson.localdomain>
 <54A06874.7050006@gannon.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A06874.7050006@gannon.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 09:30:44PM +0100, Jonas Lundqvist wrote:
> Hi Jeremiah,
> 
> On 12/28/2014 04:44 PM, Jeremiah Mahler wrote:
> > Jonas,
> > 
> > On Sun, Dec 28, 2014 at 02:26:46PM +0100, Jonas Lundqvist wrote:
> >> Fixed three errors in pcm.h found by checkpatch.pl.
> > 
> > What type of errors did you fix?
> 
> These errors:
> drivers/staging/line6/pcm.h:148: ERROR: space prohibited before that ','
> (ctx:WxE)
> drivers/staging/line6/pcm.h:155: ERROR: space prohibited before that ','
> (ctx:WxE)
> drivers/staging/line6/pcm.h:162: ERROR: space prohibited before that ','
> (ctx:WxE)

I am sure Jeremiah Mahler actually wanted to tell you that you should include that information in the commit log. We always mention what kind of error was fixed.


thanks
sudip
> 
> 
> BR
> Jonas
> 


