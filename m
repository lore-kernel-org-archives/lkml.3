Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaGLAiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:38:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaGLAiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:38:20 -0400
Date: Fri, 11 Jul 2014 17:42:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] serial: imx: Fix build breakage
Message-ID: <20140712004248.GA24760@kroah.com>
References: <20140711112108.7631911b@canb.auug.org.au>
 <1405046206-14495-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405046206-14495-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:36:46PM -0400, Peter Hurley wrote:
> Fix breakage introduced by
> commit c557d392fbf5badd693ea1946a4317c87a26a716,
> 'serial: Test for no tx data on tx restart'.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

You forgot a "Reported-by:" tag.

I'll go add it...

