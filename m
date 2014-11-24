Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaKXQxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:53:10 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53242 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbaKXQxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:53:08 -0500
X-Sasl-enc: 31IIrgyW67XFShkXdxHL03uSCkkSfqrdH+gI9Tlix1/y 1416847987
Date: Mon, 24 Nov 2014 08:53:06 -0800
From: Greg KH <greg@kroah.com>
To: Balavasu kuppusammyprathaban <kp.balavasu@gmail.com>
Cc: linux-kernel@vger.kernel.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com
Subject: Re: [PATCH 1/2] staging: lustre: lnet: lnet: do not initialise
 statics to 0 or NULL
Message-ID: <20141124165306.GA4450@kroah.com>
References: <20141124060318.GA13501@vasu-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124060318.GA13501@vasu-Inspiron-3542>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:33:18AM +0530, Balavasu kuppusammyprathaban wrote:
> This patch fixes the checkpatch.pl issue
> Error: do not initialise statics to 0 or NULL 
> 
> Signed-off-by: Balavasu kuppusammyprathaban<kp.balavasu@gmail.com>
> ---
>  drivers/staging/lustre/lnet/lnet/router.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Any reason why you aren't using scripts/get_maintainer.pl?

Also, you need a ' ' after your name and before the '<' character.

As well as properly capitalizing your name.

Please redo both patches.
