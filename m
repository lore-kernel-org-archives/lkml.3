Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423667Ab3FUS7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:59:54 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:35718 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423424Ab3FUS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:59:52 -0400
Message-ID: <51C4A2A1.8060801@suse.cz>
Date: Fri, 21 Jun 2013 20:59:45 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        stable@vger.kernel.org, Frederic Crozat <fcrozat@suse.com>
Subject: Re: [PATCH -resend] drm/nouveau: use vmalloc for pgt allocation
References: <1371841034-24893-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1371841034-24893-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scratch this one. It's missing CCs.

On 06/21/2013 08:57 PM, Jiri Slaby wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> Page tables on nv50 take 48kB, which can be hard to allocate in one piece.
> Let's use vmalloc.


-- 
js
suse labs
