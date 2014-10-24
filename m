Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaJXOZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:25:49 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34527 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJXOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:25:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+N1TtDf/nBJC1frv861b/u5p8+vlWSx/E=
X-DKIM: OpenDKIM Filter v2.0.1 titan 72AFD60765E
Date: Fri, 24 Oct 2014 10:25:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] staging: skein: Renames skein to skein_base
Message-ID: <20141024142542.GB12718@titan.lakedaemon.net>
References: <cover.1414151639.git.eric.rost@mybabylon.net>
 <b60dcbe0965eba783e26007d46ed47b0004a65fb.1414151639.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b60dcbe0965eba783e26007d46ed47b0004a65fb.1414151639.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 06:55:16AM -0500, Eric Rost wrote:
> Renames skein.c to skein_base.c and skein.h to skein_base.h

It's worth a mention in here that this is in preparation for skein.ko.

> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/Makefile        |   2 +-
>  drivers/staging/skein/skein.c         | 883 ---------------------------------
>  drivers/staging/skein/skein.h         | 346 -------------
>  drivers/staging/skein/skein_api.h     |   2 +-
>  drivers/staging/skein/skein_base.c    | 884 ++++++++++++++++++++++++++++++++++
>  drivers/staging/skein/skein_base.h    | 351 ++++++++++++++
>  drivers/staging/skein/skein_block.c   |   2 +-
>  drivers/staging/skein/skein_block.h   |   2 +-
>  drivers/staging/skein/skein_iv.h      |   2 +-
>  drivers/staging/skein/threefish_api.h |   2 +-
>  10 files changed, 1241 insertions(+), 1235 deletions(-)
>  delete mode 100644 drivers/staging/skein/skein.c
>  delete mode 100644 drivers/staging/skein/skein.h
>  create mode 100644 drivers/staging/skein/skein_base.c
>  create mode 100644 drivers/staging/skein/skein_base.h

you can add '-M' to diff or format-patch to detect renames.  It'll make
this patch a *lot* smaller, and allow us to see more easily that nothing
changed.  Well, other than the #include rename inside {skein.c
->skein_base.c}.

thx,

Jason.
