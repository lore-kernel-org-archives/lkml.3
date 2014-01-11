Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaAKUgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:36:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAKUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:36:47 -0500
Date: Sat, 11 Jan 2014 12:36:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: bergwolf@gmail.com, andreas.dilger@intel.com, keith.mannthey@intel.com,
        oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Staging: lustre: Fix return does not need
 parantheses
Message-ID: <20140111203651.GB6501@kroah.com>
References: <1389470502-26243-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389470502-26243-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 01:31:41AM +0530, Monam Agarwal wrote:
> The patch fixes the following checkpatch.pl error in
> lustre/ldlm/ldlm_flock.c
> ERROR: return is not a function, parentheses are not required 
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

I'm totally confused here.  You have multiple series of patches, sent
with different version numbers, some with the same subjects, and some
not.

I've deleted all of your lustre patches from my queue because of this, I
don't want to apply something incorrectly.

Please step back, take a day, and resend all of your pending patches
that I have not applied for the lustre code, in a single series, so I
know what I should be looking at here.

There's no rush, so please take your time and do your best to keep an
overworked maintainer from getting things wrong.

thanks,

greg k-h
