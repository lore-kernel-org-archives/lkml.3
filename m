Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaLOTcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:32:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaLOTcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:32:50 -0500
Date: Mon, 15 Dec 2014 11:32:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jack Wilson <jackwilson128@gmail.com>
Cc: mail@beyermatthias.de, davej@redhat.com, ebru.akagunduz@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: fix spaces before commas in Bcmchar.c
Message-ID: <20141215193249.GB9842@kroah.com>
References: <1418671349-4014-1-git-send-email-jackwilson128@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418671349-4014-1-git-send-email-jackwilson128@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:22:29AM -0800, Jack Wilson wrote:
> This is a patch to the Bcmchar.c file that fixes a space before comma warning found by checkpatch.pl.
> Signed-off-by: Jack Wilson <jackwilson128@gmail.com>
> ---
>  drivers/staging/bcm/Bcmchar.c | 4 ++--

Odd, that file is gone from my tree, I have no idea what tree you are
working against here...
