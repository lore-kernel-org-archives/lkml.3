Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbaHFTHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:07:08 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36539 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaHFTHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:07:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140806190412.GA5605@roeck-us.net>
References: <CAO+Sx3nGKN1jh0VB9NjcFCqV7ZmWWjJge0nohdUGta9BF60EWQ@mail.gmail.com>
	<20140806190412.GA5605@roeck-us.net>
Date: Wed, 6 Aug 2014 21:07:04 +0200
X-Google-Sender-Auth: 5yOMagfIJ2xqq3t0g4hZMahshcc
Message-ID: <CAO+Sx3ncSgmdQq-PyZwXzN-ZJJ+0VD+kNVNJYzir+mHzVwxbdw@mail.gmail.com>
Subject: Re: [PATCH] spi: Fix warning about redefinition
From: David Wood <david@dtwood.co.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Nick Krause <xerofoiffy@gmail.com>, Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 August 2014 21:04, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Aug 06, 2014 at 08:53:41PM +0200, David Wood wrote:
> ...
> That was purely to ensure that there is no hidden use through a macro
> defined elsewhere, not a suggestion for a real patch.
>
> Guenter

I also managed not to notice that I had in fact shown that the fs.h
definitions were the opposite of those in the spi driver, so it would
in fact be significant if they were swapped.

David
