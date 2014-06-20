Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966514AbaFTAEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:04:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaFTAEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:04:02 -0400
Date: Thu, 19 Jun 2014 17:08:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Bay <christian.bay@studium.fau.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        lisa@xenapiadmin.com, linux-kernel@i4.cs.fau.de,
        Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Subject: Re: [PATCH 1/2] Staging: bcm: Prototypes.h: fix checkpatch errors
Message-ID: <20140620000802.GA9753@kroah.com>
References: <1403100606-14881-1-git-send-email-christian.bay@studium.fau.de>
 <1403100606-14881-2-git-send-email-christian.bay@studium.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403100606-14881-2-git-send-email-christian.bay@studium.fau.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 04:10:05PM +0200, Christian Bay wrote:
> This patch fixes all errors, excluding > 80 character warnings, shown by the checkpatch
> script. In detail whitespace changes according to the coding guideline are meant.
> Additionally there is exactly one newline after every declaration of methods now.

Please break this up into a "do one thing at a time" set of patches.

thanks,

greg k-h
