Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab3DIIvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:51:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3DIIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:51:08 -0400
Date: Tue, 9 Apr 2013 09:51:01 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 054/102] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
Message-ID: <20130409085101.GA3131@hercules>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
 <1365414657-29191-55-git-send-email-luis.henriques@canonical.com>
 <477F20668A386D41ADCC57781B1F70430D9DE9605C@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DE9605C@SC-VEXCH1.marvell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bing,

On Mon, Apr 08, 2013 at 11:03:32AM -0700, Bing Zhao wrote:
> Hi Luis,
> 
> > 3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Bing Zhao <bzhao@marvell.com>
> > 
> > commit 084c7189acb3f969c855536166042e27f5dd703f upstream.
> > 
> > curr_cmd points to the command that is in processing or waiting
> > for its command response from firmware. If the function shutdown
> > happens to occur at this time we should cancel the cmd timer and
> > put the command back to free queue.
> > 
> > Tested-by: Marco Cesarano <marco@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> 
> This patch is intended for kernel 3.8+.
> Please drop it from linux-3.5.7.10 stable.

Sorry, I didn't noticed that.  I'll drop it from 3.5.  Thanks.

Cheers,
--
Luis
