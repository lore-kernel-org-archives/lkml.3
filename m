Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab3DJOgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:36:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51679 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760108Ab3DJOf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:35:59 -0400
Message-ID: <1365604558.27174.36.camel@joe-AO722>
Subject: Re: checkpatch: kill the bogus camelcase check
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Wed, 10 Apr 2013 07:35:58 -0700
In-Reply-To: <20130410132628.GV7511@dm>
References: <1365544254.2946.53.camel@dabdike> <20130410132628.GV7511@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 14:26 +0100, Andy Whitcroft wrote:
> On Tue, Apr 09, 2013 at 02:50:54PM -0700, James Bottomley wrote:
> > It's making checkpatch unusable on most drivers because it's spewing
> > tons of bogus warnings.  The problem is the assumption that studly caps
> > is always wrong: it isn't if the variables are named after the various
> > conventions in the hardware programming guides (which are usually
> > written by Microsoft people).
> > 
> > In order to encourage people to use checkpatch, it has to be *useful* it
> > can't stray too far into dogmatic things like this that are essentially
> > unfixable by most people who submit patches.
> > 
> > Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> 
> Joe, perhaps this could become a strict check?

or maybe exclude drivers/scsi and include/scsi/

