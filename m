Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbbAOIRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:17:47 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:50877 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbAOIRq (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 03:17:46 -0500
Message-ID: <1421309845.17403.6.camel@stgolabs.net>
Subject: Re: [PATCH] sound/oss: use current->state helpers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Veliath <andrewtv@usa.net>, Jaroslav Kysela <perex@perex.cz>,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2015 00:17:25 -0800
In-Reply-To: <s5htwzszcmw.wl-tiwai@suse.de>
References: <1421305903.17403.0.camel@stgolabs.net>
	 <s5hzj9kzeex.wl-tiwai@suse.de> <1421308290.17403.4.camel@stgolabs.net>
	 <s5htwzszcmw.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 09:11 +0100, Takashi Iwai wrote:
> Well, it's a bit unusual.  Why do they need to differ?  Is the author
> another Davidlohr? :)  If this form is preferred, I'm willing to
> apply, but I just wonder...

Personal taste, really. Yes I'd prefer you apply as is.

Thanks,
Davidlohr

