Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaKCXYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:24:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKCXYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:24:39 -0500
Date: Mon, 3 Nov 2014 15:24:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        pebolle@tiscali.nl, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3] usb: Remove references to non-existent PLAT_S5P symbol
Message-ID: <20141103232438.GA11698@kroah.com>
References: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 11:12:07AM +0200, Sylwester Nawrocki wrote:
> The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
> ("ARM: SAMSUNG: Remove remaining legacy code"). There are still
> some references left, fix that by replacing them with ARCH_S5PV210.
> 
> Fixes: d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Cc: <stable@vger.kernel.org>	[3.17+]

This isn't a stable issue...

