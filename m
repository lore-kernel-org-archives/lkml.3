Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3EGT3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:29:51 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34030 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3EGT3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:29:49 -0400
Date: Tue, 7 May 2013 21:29:38 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 15/15] ptp: PTP_1588_CLOCK_PCH depends on x86
Message-ID: <20130507192938.GA3599@netboy>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
 <1367936303-13386-15-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367936303-13386-15-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:18:23PM +0200, Jiri Slaby wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> The PCH EG20T is only compatible with Intel Atom processors so it
> should depend on x86.

This patch has been submitted before,

   https://patchwork.kernel.org/patch/2069071/

and at that time the reaction was that it is good to have drivers
cross-compiled, if only for code quality reasons.

Thanks,
Richard
