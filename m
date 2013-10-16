Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424Ab3JPTMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:12:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3JPTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:12:03 -0400
Date: Wed, 16 Oct 2013 12:12:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dhanunjaya <dhanunjaya.matrix@gmail.com>
Cc: arnaud.patard@rtp-net.org, aaro.koskinen@iki.fi, peterhuewe@gmx.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Staging: xgifb: fix braces {} are not necessary for
 single statement blocks
Message-ID: <20131016191202.GB19071@kroah.com>
References: <1381949494-19886-1-git-send-email-dhanunjaya.matrix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381949494-19886-1-git-send-email-dhanunjaya.matrix@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where are patches 1/4 and 2/4 in this series?

On Thu, Oct 17, 2013 at 12:21:33AM +0530, Dhanunjaya wrote:
> This is a patch to the vb_setmode.c file that fixes braces {}
> are not necessary for single statement blocks warning found
> by the checkpatch.pl tool
> 
> Signed-of-by: Dhanunjaya <dhanunjaya.matrix@gmail.com>

Again, I need a full name before I can take any of these patches.

