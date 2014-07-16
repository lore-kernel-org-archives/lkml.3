Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbaGPCzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:55:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54637 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaGPCzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:55:50 -0400
Date: Wed, 16 Jul 2014 10:55:45 +0800
From: Stone Kang <stonekyx@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm+renesas@opensource.se>,
        Sachin Kamat <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: emxx_udc: Fix coding style errors
Message-ID: <20140716025545.GA27842@stone-arch>
References: <1405473375-29825-1-git-send-email-stonekyx@gmail.com>
 <20140716022128.GA22440@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716022128.GA22440@kroah.com>
X-PGP-Key: 8146154F
User-Agent: Mutt/1.5.23+7 (375ba5ce358c) (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Jul 15, 2014 at 07:21:28PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Jul 16, 2014 at 09:16:15AM +0800, Stone Kang wrote:
> > Only fixing errors reported by checkpatch.pl, based on the following
> > rules:
> > 1. '*' should be adjacent to the data name or function name.
> > 2. Don't use C99-style "// ..." comments.
> > 
> > Signed-off-by: KANG Yuxuan <stonekyx@gmail.com>
> 
> I see two different names here, one in the "From:" line, and one in the
> Signed-off-by: line, are they the same?  They need to match up :(
> 
> Please resend with this fixed.
> 
> thanks,
> 
> greg k-h

Sorry, I forgot to set the From: line.

New patch has been sent, but as the content didn't change, no 'v2' tag
was attached in the title.
