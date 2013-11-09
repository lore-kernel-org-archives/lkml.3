Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3KINWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 08:22:12 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36803 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3KINWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 08:22:08 -0500
Message-ID: <527E36FC.2090208@linux.com>
Date: Sat, 09 Nov 2013 14:22:04 +0100
From: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Baptiste Covolato <b.covolato@gmail.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: Add possibility to compile android
 drivers as modules
References: <1384003422-24683-1-git-send-email-b.covolato@gmail.com>	<527E30BD.3030604@linux.com> <CAP_kqcjdZGdL6rq+vnhf3qAWhMGoBhrR8A4bcJh=wATQjGqgyQ@mail.gmail.com>
In-Reply-To: <CAP_kqcjdZGdL6rq+vnhf3qAWhMGoBhrR8A4bcJh=wATQjGqgyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-09 14:15 keltezéssel, Baptiste Covolato írta:
> Thanks for the review.
> 
> Should I repost this patch with correct git commit message here or in
> another mail ?

Post it a new mail with a subject like [PATCH v2] or something among the lines.

Also, have you tested that they compile as modules and can be insmod'ed?

-- 
Regards,
Levente Kurusa
