Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab3FTMYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:24:01 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43865 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab3FTMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:23:59 -0400
Date: Thu, 20 Jun 2013 14:23:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
        rostedt@goodmis.org, daniel@ffwll.ch, tglx@linutronix.de,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v5 2/7] mutex: add support for wound/wait style locks, v5
Message-ID: <20130620122355.GA15814@gmail.com>
References: <20130620112811.4001.86934.stgit@patser>
 <20130620113111.4001.47384.stgit@patser>
 <20130620115532.GA12479@gmail.com>
 <51C2F2A0.3080606@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C2F2A0.3080606@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:

> Well they've helped me with some of the changes and contributed some 
> code and/or fixes, but if acked-by is preferred I'll use that..

Such contributions can be credited in the changelog, and/or copyright 
notices, and/or the code itself. The signoff chain on the other hand is 
strictly defined as a 'route the patch took', with a single point of 
origin, the main author. See Documentation/SubmittingPatches, pt 12.

[ A signoff chain _can_ signal multi-authored code where the code got 
  written by someone and then further fixed/developed by someone else - 
  who adds a SOB to the end - but in that case I expect to get the patch 
  from the last person in the signoff chain. ]

Thanks,

	Ingo
