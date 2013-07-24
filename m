Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3GXUOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:14:34 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:40483 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3GXUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <1374694998.7382.33.camel@dabdike>
References: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
	<1374694998.7382.33.camel@dabdike>
Date: Wed, 24 Jul 2013 13:14:31 -0700
Message-ID: <CA+8MBbL+GqQQ8-_=D=qOVj9qa1RebtmaF9spHR6NcHMTPrQpFw@mail.gmail.com>
Subject: Re: scsi scan: INQUIRY result too short (5), using 36
From: Tony Luck <tony.luck@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:43 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Oops, apparently no-one I cc'd at intel actually bothered to check the
> patch for the isci driver.  The looks to be that sci_swab32_cpy needs
> multiples of four, so for commands that aren't that, it's rounding the
> wrong way.  Does this fix it?

Yes. That fixes it.

Wrap whichever of:

Reported-by: Tony Luck <tony.luck@intel.com>

and/or

Tested-by: Tony Luck <tony.luck@intel.com>

around that patch and ship it!

Thanks for the fast fix.

-Tony
