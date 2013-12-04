Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab3LDX4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:56:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3LDX4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:56:22 -0500
Date: Wed, 4 Dec 2013 15:29:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/2] MIPS/staging: Probe octeon-usb driver via device-tree
Message-ID: <20131204232953.GA7698@kroah.com>
References: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386100012-6077-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:46:50AM -0800, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Tested against both EdgeRouter LITE (no bootloader supplied device
> tree), and ebb5610 (device tree supplied by bootloader).
> 
> The patch set is spread across both the MIPS and staging trees, so it
> would be great if Ralf could merge at least the MIPS parts, if not
> both parts.

That's fine with me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
