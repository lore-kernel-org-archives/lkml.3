Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3BFTRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:17:12 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38380 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3BFTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:17:10 -0500
Date: Wed, 6 Feb 2013 11:17:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Millenbach <jmillenbach@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Jamey Sharp <jamey@minilop.net>
Subject: Re: [PATCH] input: drop unnecessary dependencies on TTY
Message-ID: <20130206191706.GA27985@core.coreip.homeip.net>
References: <1360115914-4334-1-git-send-email-jmillenbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360115914-4334-1-git-send-email-jmillenbach@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:58:34PM -0800, Joe Millenbach wrote:
> Backing out changes made in earlier TTY removal patch.  Switched
> to only one dependency in SERPORT on TTY instead of many incorrect
> dependencies.
> 
> Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
> Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks for doing this!

-- 
Dmitry
