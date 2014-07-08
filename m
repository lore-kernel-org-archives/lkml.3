Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaGHQn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:43:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49493 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGHQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:43:57 -0400
Date: Tue, 8 Jul 2014 09:43:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Nick Krause <xerofoify@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        mahesh <mahesh@linux.vnet.ibm.com>, Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>, paulus@samba.org,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: Fwd: powerpc allyesconfig fix
Message-ID: <20140708164352.GA12935@roeck-us.net>
References: <1404795849-25609-1-git-send-email-xerofoify@gmail.com>
 <20140708160417.47fb4d7c@canb.auug.org.au>
 <CAPDOMVitjYMkoLAbwf6oBJg+fpFdKLi+S4hTm6opD27DMC1NDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVitjYMkoLAbwf6oBJg+fpFdKLi+S4hTm6opD27DMC1NDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 12:35:27PM -0400, Nick Krause wrote:
> From: Stephen Rothwell wrote on Tue, Jul 8, 2014 at 2:04 AM
> Subject: Re: powerpc allyesconfig fix
> 
> Hi Nicholas,
> 
> On Tue,  8 Jul 2014 01:04:09 -0400 Nicholas Krause <xerofoify@gmail.com> wrote:
> >
> > powerpc:allmodconfig has been failing for some time with the following
> > error.
> 
> This patch has already bee submitted directly by Guenter, however for
> future reference:  when you submit someone else's patch, you should
> include a From line as the first line of the email body containing their
> email address and you should include a Signed-off-by line from yourself.
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> 
> Hey Stephen,
> Thanks for the heads up on submitting other people's patches. It would
> be great if you can push this up into Linus's tree
> for the next developer release.

Ben already mentioned that he would pick it up.

Guenter
