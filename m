Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaBJPHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:07:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53642 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaBJPH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:07:29 -0500
Date: Mon, 10 Feb 2014 15:07:19 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: Add CPU model 54 (Atom N2000 series)
Message-ID: <20140210150719.603f8e5a@alan.etchedpixels.co.uk>
In-Reply-To: <52E42B86.1020701@web.de>
References: <52E42B86.1020701@web.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014 22:24:22 +0100
Jan Kiszka <jan.kiszka@web.de> wrote:

> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Add CPU ID for Atom N2600/N2800 processors. Datasheets indicate support
> for this, detailed information about potential quirks or limitations are
> missing, though. So we just reuse the definition for the previous ATOM
> series. Tests on N2800 systems showed that this addition is fine an can
> reduce power consumption by about 0.25 W (personally confirmed on Intel
> DN2800MT).
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Len - what's going on with this, and with the other identical patches
people have posted ? This still doesn't seem to be in -next which leaves
the various Cedartrail platforms still not covered by intel_idle.
Likewise the same with Oaktrail, despite patches being submitted several
times over the past two years ?

Alan
