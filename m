Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaHYTiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:38:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaHYTh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:37:58 -0400
Date: Mon, 25 Aug 2014 12:37:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [3.8.y.z extended stable] Linux 3.8.13.28 stable review
Message-ID: <20140825193716.GB18708@kroah.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
 <20140825170033.GA18021@kroah.com>
 <1408994058.8997.33.camel@fourier>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408994058.8997.33.camel@fourier>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 12:14:18PM -0700, Kamal Mostafa wrote:
> On Mon, 2014-08-25 at 10:00 -0700, Greg KH wrote:
> > On Mon, Aug 25, 2014 at 09:54:46AM -0700, Kamal Mostafa wrote:
> > > This is the start of the review cycle for the Linux 3.8.13.28 stable kernel.
> > > 
> > >  ** NOTE: This will be the last Linux 3.8.y.z extended stable version
> > >  ** to be released and supported by me and the Ubuntu Kernel team.
> > 
> > I know this is the last release, but I have gotten some complaints by
> > people who are confused by the numbering scheme you are using for the
> > Canonical stable kernel releases.  Can you please use the EXTRAVERSION
> > field with a "-something" tag in it to differenciate from the "normal"
> > kernel.org stable releases?
> 
> We'll consider that idea for future extended stable versions maintained
> by our team.

Thank you very much, that should help reduce the current confusion.

greg k-h
