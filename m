Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbbAETXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:23:42 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:60883 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbAETXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:23:41 -0500
Date: Mon, 5 Jan 2015 19:23:29 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>, luto@amacapital.net
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20150105192329.5f32c155@lxorguk.ukuu.org.uk>
In-Reply-To: <20141224220818.GA17655@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
	<20141224220818.GA17655@amd>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the meantime, I created test that actually uses physical memory,
> 8MB apart, as described in some footnote. It is attached. It should
> work, but it needs boot with specific config options and specific
> kernel parameters.

Why not just use hugepages. You know the alignment guarantees for 1GB
pages and that means you don't even need to be root

In fact - should we be disabling 1GB huge page support by default at this
point, at least on non ECC boxes ?

Alan
