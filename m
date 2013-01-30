Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3A3Pzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:55:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:59046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab3A3Pzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:55:53 -0500
Date: Wed, 30 Jan 2013 16:57:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Message-ID: <20130130155746.GA18174@kroah.com>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:37:25PM +0000, Kurachkin Michail wrote:
> Hi Greg,
> 
> I followed your recommendations and created a diff using Linux 3.8-rc5
> sources. Please review it and give your comments.

As-is, it looks good enough to add to the staging tree, so can you
resend it, not as a base64 attachment, with a Signed-off-by: line (as
described in the kernel file, Documentation/SubmittingPatches) and we
can work to clean up the code in the kernel based on Oliver's comments.

thanks,

greg k-h
