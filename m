Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaF1QAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 12:00:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaF1QAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 12:00:32 -0400
Date: Sat, 28 Jun 2014 12:00:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kiran Kankipati <kiran.kankipati@gmail.com>
Cc: "Don A. Bailey" <donb@securitymouse.com>, linux-kernel@vger.kernel.org
Subject: Re: Bug in Kernel's LZ4-HC in 64bit (kernel crypto library)
Message-ID: <20140628160020.GA11019@kroah.com>
References: <CALWnrFRO_trdJ7aL_vaWtFbdJgxRkt4+zROR_chQFNPz7v3BVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALWnrFRO_trdJ7aL_vaWtFbdJgxRkt4+zROR_chQFNPz7v3BVQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 09:19:34PM +0530, Kiran Kankipati wrote:
> Hi Something similar to that I got inconsistency issue in LZ4-HC in 64bit mode.
> 
> I posted today in kernel bugzee:  https://bugzilla.kernel.org/show_bug.cgi?id=79091

I don't do bugzilla :)

Let's drag this back to lkml as well...

Ok, where do you see an overrun happening?  I know the lz4 code in the
kernel is "old" compared to upstream.  I am working on updating it to
the latest version, but that's not going to happen until 3.17.

In the mean time, did you note the lz4 patch that was merged yesterday,
it is commit id 4148c1f67abf823099b2d7db6851e4aea407f5ee in Linus's
tree.  Does that solve the issue you are seeing?

If not, do you have a data stream I can use to try to find and fix this?

thanks,

greg k-h
