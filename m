Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaDYReQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:34:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:57771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaDYReO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,928,1389772800"; 
   d="scan'208";a="499831523"
Date: Fri, 25 Apr 2014 10:32:06 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] xhci: fixes for 3.15-rc usb-linus
Message-ID: <20140425173206.GA19900@xanatos>
References: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com>
 <20140425163505.GA8382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425163505.GA8382@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 09:35:05AM -0700, Greg KH wrote:
> On Fri, Apr 25, 2014 at 07:20:12PM +0300, Mathias Nyman wrote:
> > Hi Greg                                                                                                
> >                                                                                                        
> > Second try at this xhci fixes series for 3.15-rc usb-linus.                                                         
> > Most of them are very small fixes that didn't make                                                     
> > it to 3.14, sitting and waiting for 3.15-rc1 to come out.                                              
> >                                                                                                        
> > Only the "Prefer endpoint context.." patch  by Julius has a bit more content.                          
> >                                                                                                        
> > These patches are picked together with Sarah, they are tested on top of                                
> > 3.15-rc1, and apply on your current usb-linus branch                                                   
> 
> Much better, all now applied.
> 
> What's with all that trailing whitespace in your email text?

I use the following lines in my .vimrc to highlight trailing whitespace:

hi link localWhitespaceError Error
au Syntax * syn match localWhitespaceError /\(\zs\%#\|\s\)\+$/ display
au Syntax * syn match localWhitespaceError / \+\ze\t/ display

I also have a macro to add stable tags and which commit IDs introduced
the issue the bug fixes:

iab backporthis
\<CR>Fixes: commitID ("commitDescription")
\<CR>Cc: stable@vger.kernel.org # kernelVersion

Then when I'm amending someone's commit to add my Signed-off-by line, I
type backporthis, and vim expands it to the longer version.  (I've
deliberately misspelled it here, so it doesn't get expanded.) Sometimes
it takes a couple of round of `git blame` to figure out when the bug was
introduced.

Sarah Sharp
