Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3B0JwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:52:20 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56368 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3B0JwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:52:17 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.186.210]
In-Reply-To: <CAEvN+1hLe=aPapmu8KCcoUHJ1LkaQJ8WGs4j=82S=jj6UUCxOw@mail.gmail.com>
References: <CAEvN+1hLe=aPapmu8KCcoUHJ1LkaQJ8WGs4j=82S=jj6UUCxOw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 27 Feb 2013 11:51:57 +0200
Message-ID: <CAK=WgbYdMoeVTyXEX1ZXfLB7f7XdXsB7Q3C63VsYtyj2MYoe1A@mail.gmail.com>
Subject: Re: rpmsg: support for being called in interrupt context?
To: Tzu-Jung Lee <roylee17@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 27, 2013 at 7:44 AM, Tzu-Jung Lee <roylee17@gmail.com> wrote:
> I'm wondering is the support for being called in interrupt is on going?

Not that I know of.

> If I'd  like to help on this, any suggestion or cautions should be take care
> of?

If you want this to be merged upstream, please describe your hardware
and exact use cases so we are convinced this is indeed necessary.

Thanks,
Ohad.
