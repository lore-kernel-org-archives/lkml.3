Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3EVVzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:55:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3EVVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:55:30 -0400
Date: Wed, 22 May 2013 14:55:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernie Thompson <bhthompson@chromium.org>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org
Subject: Re: [PATCH] rtc: add in ability to push out an existing wakealarm
 using sysfs
Message-Id: <20130522145529.a03f3344f58b4b9ddacb25b7@linux-foundation.org>
In-Reply-To: <1368233611-1690-1-git-send-email-bhthompson@chromium.org>
References: <1368233611-1690-1-git-send-email-bhthompson@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013 17:53:31 -0700 Bernie Thompson <bhthompson@chromium.org> wrote:

> This adds in the ability for the rtc sysfs code to handle += characters
> at the beginning of a wakealarm setting string. This will allow the user to
> attempt to push out an existing wakealarm by a provided amount.
> 
> In the case that the += characters are provided but the alarm is not active
> -EVINVAL is returned.
> 

Well that sounds useful, but I'm not personally in a position to
confidently judge whether it's useful enough to merge the patch.  The
changelog doesn't make a compelling case and everybody else has chosen
to sit on their hands.

So I really don't know what to do with this patch.

