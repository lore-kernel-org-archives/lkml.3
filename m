Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaBJKov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:44:51 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53220 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaBJKot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:44:49 -0500
Date: Mon, 10 Feb 2014 10:44:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: screen goes blank when loading gma500_gfx (atom D2500)
Message-ID: <20140210104431.63f1a754@alan.etchedpixels.co.uk>
In-Reply-To: <52F68BEF.5030305@msgid.tls.msk.ru>
References: <52F68BEF.5030305@msgid.tls.msk.ru>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fbcon is loaded so it isn't an issue.
> 
> I tried 3.10 kernel initially (the above messages are from it), next
> I tried 3.13 kernel too, and that one behaves exactly the same.
> 
> As far as I remember, this system never worked with graphics well.
> Previous kernel (from which I updated) was 3.2 which had no
> gma500 module (local build).
> 
> What are the steps to debug this further?

Check you have X86_SYSFB and SIMPLEFB disabled

Boot with drm.debug=6

collect the logs

