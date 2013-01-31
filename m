Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3AaVmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:42:14 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49904 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab3AaVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:42:11 -0500
Message-ID: <1359668524.2468.12.camel@dabdike>
Subject: Re: [PATCH] parisc: unbreak automounter support on 64-bit kernel
 with 32-bit userspace
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org
Date: Fri, 01 Feb 2013 08:42:04 +1100
In-Reply-To: <510AE21D.2090002@zytor.com>
References: <20130131200110.GA6032@p100.box>
	 <1359664008.2468.5.camel@dabdike> <510AE21D.2090002@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-31 at 13:29 -0800, H. Peter Anvin wrote:
> On 01/31/2013 12:26 PM, James Bottomley wrote:
> > [adding autofs list and maintainer for their perusal and ack, although
> > this is an obvious fix to me
> > 
> > James]
> 
> The #if list probably should be inverted, and only specific platforms
> should have unsigned long...

The whitelist is 64 bit only platforms, like ia64, isn't it?  So yes,
they're far less numerous.

James


