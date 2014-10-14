Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaJNB2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:28:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaJNB2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:28:44 -0400
Date: Tue, 14 Oct 2014 03:27:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: George Spelvin <linux@horizon.com>
Cc: romain@orebokech.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141014012741.GB17932@kroah.com>
References: <87d29w6kl8.fsf@kima.orebokech.com>
 <20141013210346.31360.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013210346.31360.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:03:46PM -0400, George Spelvin wrote:
> Romain Francoise <romain@orebokech.com> wrote:
> > Commit 1c40279960 ("libata: Un-break ATA blacklist") is apparently not
> > included, is in Linus' tree since Friday, and is rather urgent.
> 
> As the patch author, I agree.  If nothing else, I'd like to be able to take
> off this brown paper bag.

Now queued up.

thanks,

greg k-h
