Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaBYNvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:51:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbaBYNv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:51:26 -0500
Message-ID: <1393336285.3114.8.camel@linux-fkkt.site>
Subject: Re: USB keyboard occasional key stuck
From: Oliver Neukum <oneukum@suse.de>
To: Daniel J Blueman <daniel@quora.org>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Tue, 25 Feb 2014 14:51:25 +0100
In-Reply-To: <CAMVG2ss9nA4zcOT3c47EwEMrR7Z_gAQU-HTYGjdWcdYzihSnbg@mail.gmail.com>
References: <CAMVG2ss9nA4zcOT3c47EwEMrR7Z_gAQU-HTYGjdWcdYzihSnbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 21:23 +0800, Daniel J Blueman wrote:
> Across 5+ years of kernels, I've been seeing occasional (1-2 times per
> day) key-stuck issues where eg a fn+delete combo repeats delete until
> I press delete again. I've seen this happen with fn+ctrl+left, leaving
> left held and likewise with right.

I saw something like this during the development of runtime PM
for HID. It turns out that keyboards don't assert remote wakeup
upon key release.

Just to rule this out can you deactivate runtime PM and recompile
to switch of LPM?

	Regards
		Oliver


