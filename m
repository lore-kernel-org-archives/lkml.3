Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaBXRUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:20:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaBXRUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:20:02 -0500
Date: Mon, 24 Feb 2014 09:22:51 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [RFC] drivercore: deferral race condition fix
Message-ID: <20140224172251.GA30194@kroah.com>
References: <1387802491-14513-1-git-send-email-peter.ujfalusi@ti.com>
 <20140224014032.GT25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224014032.GT25940@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:40:32AM +0900, Mark Brown wrote:
> On Mon, Dec 23, 2013 at 02:41:31PM +0200, Peter Ujfalusi wrote:
> 
> > The proposed solution is to try the deferred queue once more when the last
> > driver is asking for deferring and we had drivers probed while this last
> > driver was probing.
> 
> Greg, this patch doesn't seem to have been applied but it looks like
> it's addressing a real issue and seems like a reasonable fix?  Peter's
> analysis seems good to me.

I really don't remember, it's not in my queue anymore, as I can't apply
[RFC] patches :(
