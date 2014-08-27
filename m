Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbaH0MIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:08:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43191 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaH0MIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:08:12 -0400
Date: Wed, 27 Aug 2014 13:08:06 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH v3 part1 0/4] Fix SG_IO ambiguity between READ SUBCHANNEL
 and UNMAP (and other similar cases)
Message-ID: <20140827120806.GF10937@hercules>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
 <20140827093437.GA10937@hercules>
 <53FDAE65.3080208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FDAE65.3080208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 12:09:41PM +0200, Paolo Bonzini wrote:
> Il 27/08/2014 11:34, Luis Henriques ha scritto:
> > > The SG_IO ioctl's command whitelist is designed for MMC devices (roughly,
> > > "play/burn CDs without requiring root") but some opcodes overlap across SCSI
> > > device classes and have different meanings for different classes.
> > > 
> > > To fix this, use different bitmaps for the various device classes.
> > > This is CVE-2012-4542.
> >
> > Sorry for bringing this old issue again, but I was wondering what
> > happen to this fix.
> 
> Nothing; everybody lost interest in it.

Thanks a lot for the update, Paolo.

This is what I was actually expecting, although it's somewhat
surprising, taking into account this is a security issue :-)

Cheers,
--
Luís
