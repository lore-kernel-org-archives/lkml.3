Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3JLXHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 19:07:41 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:56130 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3JLXHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 19:07:40 -0400
Date: Sun, 13 Oct 2013 02:07:32 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: USB regression in v3.12-rc4
Message-ID: <20131012230732.GE29989@blackmetal.musicnaut.iki.fi>
References: <20131012214618.GD29989@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012214618.GD29989@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 13, 2013 at 12:46:18AM +0300, Aaro Koskinen wrote:
> With v3.12-rc4 I can no longer connect to N800 (OMAP2) with USB
> (peripheral, g_ether).

To clarify, I was running v3.12-rc4 on N800/peripheral side and that's
where the problem is; on host side I'm running some old Debian kernel.

A.
