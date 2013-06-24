Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab3FXVpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:45:31 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35352 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab3FXVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:45:30 -0400
Message-ID: <1372110327.2013.82.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH RESEND v2 0/2] scsi: Port buslogic driver to 64 bits
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Jun 2013 14:45:27 -0700
In-Reply-To: <51C8B75C.8040606@oracle.com>
References: <cover.1368754558.git.khalid.aziz@oracle.com>
	 <1372107313.2013.81.camel@dabdike.int.hansenpartnership.com>
	 <51C8B75C.8040606@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 15:17 -0600, Khalid Aziz wrote:
> On 06/24/2013 02:55 PM, James Bottomley wrote:
> > On Mon, 2013-06-24 at 14:25 -0600, Khalid Aziz wrote:
> >> This patchset ports buslogic driver to 64-bit.
> >
> > OK, thought long and hard about this., I'll take it on the proviso that
> > you're the new buslogic maintainer.  The reason being that without
> > someone to sort through any bug reports, the only option I have on a bug
> > which is in the rework but not the original would be to revert to the
> > original.
> 
> 
> James,
> 
> Understood. I am ok with this.

Great, you owe me a patch updating MAINTAINERS.

Thanks,

James


