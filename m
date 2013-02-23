Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3BWAjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:39:01 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:41010 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab3BWAjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:39:00 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2013 19:39:00 EST
User-Agent: K-9 Mail for Android
In-Reply-To: <51272257.7050907@oberhumer.com>
References: <51272257.7050907@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] PM: align buffers for LZO compression
From: Bojan Smojver <bojan@rexursive.com>
Date: Sat, 23 Feb 2013 11:32:08 +1100
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>
Message-ID: <a9ab9b44-5b41-40d1-b204-7b164832e4f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Markus F.X.J. Oberhumer" <markus@oberhumer.com> wrote:

>for performance reasons I'd strongly suggest that you explicitly align
>all
>buffers passed to the LZO compress and decompress functions.
>
>Below is a small (and completely untested!) patch, but I think you
>get the idea.

Do you know what kind of performance gains should be expected from this?

--
Bojan
