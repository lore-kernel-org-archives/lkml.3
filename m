Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KRO2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:28:21 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:49652 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3KRO2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:28:15 -0500
Date: Mon, 18 Nov 2013 14:28:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Constify struct mfd_cell where possible
Message-ID: <20131118142811.GK13640@lee--X1>
References: <1384779449-1888-1-git-send-email-geert@linux-m68k.org>
 <20131118130616.GI13640@lee--X1>
 <CAMuHMdWKi9oPJnn92ARAZG6qnFgxwfBrKCLnYdVv8MNUVjJCyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWKi9oPJnn92ARAZG6qnFgxwfBrKCLnYdVv8MNUVjJCyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Geert Uytterhoeven wrote:

> On Mon, Nov 18, 2013 at 2:06 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > In the interests of bisectability and revertability, I'd prefer one
> > patch per file-change where possible please. Or at the very least in
> > groups of files, so one for tps*, another one for max*, etc.
> 
> Done. More SoB-credits for me ;-)

You're welcome. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
