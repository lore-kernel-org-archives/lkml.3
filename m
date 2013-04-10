Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3DJN0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:26:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34606 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3DJN0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:26:38 -0400
Date: Wed, 10 Apr 2013 14:26:28 +0100
From: Andy Whitcroft <apw@canonical.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: checkpatch: kill the bogus camelcase check
Message-ID: <20130410132628.GV7511@dm>
References: <1365544254.2946.53.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365544254.2946.53.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:50:54PM -0700, James Bottomley wrote:
> It's making checkpatch unusable on most drivers because it's spewing
> tons of bogus warnings.  The problem is the assumption that studly caps
> is always wrong: it isn't if the variables are named after the various
> conventions in the hardware programming guides (which are usually
> written by Microsoft people).
> 
> In order to encourage people to use checkpatch, it has to be *useful* it
> can't stray too far into dogmatic things like this that are essentially
> unfixable by most people who submit patches.
> 
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>

Joe, perhaps this could become a strict check?

-apw
