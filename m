Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaIJN5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:57:17 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:51612 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaIJN5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:57:12 -0400
Message-ID: <1410357424.2761.5.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] sound: aoa: printk replacement
From: Johannes Berg <johannes@sipsolutions.net>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 15:57:04 +0200
In-Reply-To: <1410357107-29933-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20140910_155200_822543_7A3FBE01)
References: <1410357107-29933-1-git-send-email-sudipm.mukherjee@gmail.com>
	 (sfid-20140910_155200_822543_7A3FBE01)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 19:21 +0530, Sudip Mukherjee wrote:
> as pr_* macros are more preffered over printk, so printk replaced
> with corresponding pr_* macros.

Are you simply running checkpatch on every file and decided to do
something about it? :)

I'll let Takashi decide whether to take this or not as I no longer care
about this code, but IMHO this changes is completely pointless since you
don't also clean up the code to have a common prefix with #define pr_fmt
and then clean up the callers etc.

There's a reason pr_* is preferred, but random code changes like this
aren't it, I think.

johannes

