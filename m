Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070Ab3LBVb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:31:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3LBVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:31:53 -0500
Date: Mon, 2 Dec 2013 13:31:52 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alistair Popple <alistair@popple.id.au>
Subject: Re: [PATCH 3.12 056/212] ahci: add support for IBM Akebono platform
 device
Message-ID: <20131202213152.GA1932@kroah.com>
References: <20131202191248.517975703@linuxfoundation.org>
 <20131202191254.396768627@linuxfoundation.org>
 <CA+5PVA4Hzon9Kcc0aDeGbbwUuvzx08n62UTYL11LsaY8FUUBRA@mail.gmail.com>
 <CAOS58YMZaC87HMMr9huOZT2BHhg5JNNC+NedrdNmwhO=V_TgWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YMZaC87HMMr9huOZT2BHhg5JNNC+NedrdNmwhO=V_TgWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:53:06PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Mon, Dec 2, 2013 at 3:50 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> >> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> >> Signed-off-by: Tejun Heo <tj@kernel.org>
> >> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > This one is a little funny.  There's really nothing wrong with the
> > patch itself, nor adding it to 3.12.y, but it seems pretty pointless.
> > The support for the Akebono board hasn't even landed in 3.13-rcX yet,
> > and I really doubt it's going to show up in 3.12.y.  Seems kind of
> > superfluous.
> 
> I generally automatically cc stable for patches which simply add
> device IDs because they're low risk and distros / whoever is
> maintaining older kernel wants to see them. Didn't know it wouldn't
> work at all in earlier kernels. Please feel free to drop.

Ok, now dropped, thanks.

greg k-h
