Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab3E3Ul0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:41:26 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40989 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab3E3UlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:41:21 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 16:41:20 EDT
Date: Thu, 30 May 2013 22:33:10 +0200
From: Andreas Mohr <andi@lisas.de>
To: Kris Rusocki <kszysiu@braxis.org>
Cc: linux-doc@vger.kernel.org, andi@lisas.de, rob@landley.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: cover CONFIG_BINFMT_SCRIPT in init.txt
Message-ID: <20130530203310.GA5097@rhlx01.hs-esslingen.de>
References: <CAN3tLtJruJKYOmyg_XQqRW+fXQegXfxpBLg4HL1dx9e2jvjmqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN3tLtJruJKYOmyg_XQqRW+fXQegXfxpBLg4HL1dx9e2jvjmqA@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 01:24:15PM -0600, Kris Rusocki wrote:
> From: Kris Rusocki <kszysiu@braxis.org>
> 
> Now that binfmt_script is configurable, explain yet another possible
> cause of boot failure (a script w/CONFIG_BINFMT_SCRIPT != y).

Nice catch, and thanks for your effort!

It's somewhat sad to see that that file remained at only one initial commit
since 2010, thus thumbs up for your help!

Docs in general seem to be a wee bit too unmaintained.

Acked-by: Andreas Mohr <andi@lisas.de>
