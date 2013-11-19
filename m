Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3KSJc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:32:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44044 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3KSJcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:32:54 -0500
MIME-Version: 1.0
In-Reply-To: <5289ECEE.4070505@nvidia.com>
References: <1384605261-8682-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdZc0DWHe6AmawYp=SY=5==SUuJUHDETUTDw-6PbhR3tUg@mail.gmail.com>
	<5289ECEE.4070505@nvidia.com>
Date: Tue, 19 Nov 2013 10:32:54 +0100
Message-ID: <CACRpkdb0Gb9AGKqWb01=xe1423kPTXzCB+gbygsaED8Q=c95iA@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: gpiolib: document new interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 11:33 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> On 11/18/2013 06:34 PM, Linus Walleij wrote:

>> Don't we need an 00-INDEX file?
>> (Maybe Rob can tell whether this is desirable.)
>
> Good idea. gpio.txt somehow fulfills that role, but it might be better if we
> split it. Would you like me to submit a new revision?

No please just send some incremental patch on top of
my "fixes" branch in the GPIO tree.

I've read through the docs and couldn't find anything
really wrong with it BTW.

Yours,
Linus Walleij
