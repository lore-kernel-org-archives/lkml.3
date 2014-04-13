Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaDMT2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 15:28:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaDMT2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 15:28:11 -0400
Date: Sun, 13 Apr 2014 12:31:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: JulianGindi <juliangindi@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm: Fixing a few checkpatch issues in InterfaceMisc.h
Message-ID: <20140413193106.GB18071@kroah.com>
References: <20140413185654.GA80497@juliangindimbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413185654.GA80497@juliangindimbp>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 02:56:57PM -0400, JulianGindi wrote:
> Just cleaned up a few issues presented by checkpatch in InterfaceMisc.h. I converted some spaces to tabs, and removed unnecessary whitespace. The kernel version I am using linux-next-20140411.

That's a very long line, please wrap them properly.

> Signed-off-by: JulianGindi <juliangindi@gmail.com>

That might be your real name, but odds are, there needs to be a space in
there somewhere, right?

Please read Documentation/SubmittingPatches about what that line means,
and why we need a real name there.

thanks,

greg k-h
