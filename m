Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3C0IVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:21:03 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:36059 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3C0IU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:20:58 -0400
MIME-Version: 1.0
In-Reply-To: <dabdda74b7aabe3edece1c5edb9aed1c24093695.1362606482.git.dvhart@linux.intel.com>
References: <dabdda74b7aabe3edece1c5edb9aed1c24093695.1362606482.git.dvhart@linux.intel.com>
Date: Wed, 27 Mar 2013 09:20:57 +0100
Message-ID: <CACRpkdYfDRtcQ4z4PdinpNKmTHHS5+T2asSPgRGHvGK1qRL_XQ@mail.gmail.com>
Subject: Re: [PATCH] gpio-sch: Allow for more than 8 lines in the resume well
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 10:49 PM, Darren Hart <dvhart@linux.intel.com> wrote:

> The E6xx (TunnelCreek) CPUs have 9 GPIO lines in the resume well. Update
> the resume functions to allow for more than 8 GPIO lines, using the core
> functions as a template.
>
> Cc: <stable@vger.kernel.org> # 3.4.x
> Cc: <stable@vger.kernel.org> # 3.8.x
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>

I have applied this for next (v3.10)

I cannot for my life figure out what kind of *regression* you are
fixing so that it should go into fixes for the -rc:s or the two stable
branches indicated above.

I need a more verbose commit message with descriptions of
user-percieved problems on deployed systems that for that.

BTW: are you interested in adding yourself as mainatiner of
this driver in the MAINTAINERS file Darren?

Yours,
Linus Walleij
