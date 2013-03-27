Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3C0NHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:07:14 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63286 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3C0NHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:07:11 -0400
MIME-Version: 1.0
In-Reply-To: <4cbdc8777bbe14d4c8ea3b2124e9df57d497f066.1363914598.git.dvhart@linux.intel.com>
References: <4cbdc8777bbe14d4c8ea3b2124e9df57d497f066.1363914598.git.dvhart@linux.intel.com>
Date: Wed, 27 Mar 2013 14:07:10 +0100
Message-ID: <CACRpkdaxnF+OWGt7M5wTX4t9S573TDf861Jk0Auds8yKUUKBtA@mail.gmail.com>
Subject: Re: [PATCH][RESEND] gpio-sch: Allow for more than 8 lines in the
 resume well
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 2:10 AM, Darren Hart <dvhart@linux.intel.com> wrote:

> The E6xx (TunnelCreek) CPUs have 9 GPIO lines in the resume well. Update
> the resume functions to allow for more than 8 GPIO lines, using the core
> functions as a template.
>
> Cc: <stable@vger.kernel.org> # 3.4.x
> Cc: <stable@vger.kernel.org> # 3.8.x
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>

I think I replied to the first posting earlier today.
Sorry for slowness, I've been swamped.

Yours,
Linus Walleij
