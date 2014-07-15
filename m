Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030445AbaGOXrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:47:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34336 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965031AbaGOXrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:47:40 -0400
X-Sasl-enc: we2FDoeYmhsIZJaejOZ6tOMcHU3Lcvlq0zYQxMeZiW2S 1405468059
Date: Tue, 15 Jul 2014 16:52:12 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Lutomirski <amluto@gmail.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: DO NOT APPLY: x86-64, espfix: Don't leak bits 31:16 of %esp
 returning to 16-bit stack
Message-ID: <20140715235212.GC32651@kroah.com>
References: <CAObL_7EUh0F32yU+dWw802GhMp2zqaZsjc_iK-sKPnyBeJFMyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7EUh0F32yU+dWw802GhMp2zqaZsjc_iK-sKPnyBeJFMyA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:21:46PM -0700, Andrew Lutomirski wrote:
> On Tue, Jul 15, 2014 at 2:28 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> > 3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: "H. Peter Anvin" <hpa@linux.intel.com>
> >
> > commit 3891a04aafd668686239349ea58f3314ea2af86b upstream.
> 
> Do not apply to any -stable release yet.  This causes nasty regressions on Xen.

I thought you all found the Xen-regression-fix patch a few hours ago,
right?

This means that Linus's tree is also broken?

thanks,

greg k-h
