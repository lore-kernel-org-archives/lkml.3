Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3ANIkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:40:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50297 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3ANIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <2305064.Ot4klciZAj@linux-5eaq.site>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
	<CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
	<CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
	<2305064.Ot4klciZAj@linux-5eaq.site>
Date: Mon, 14 Jan 2013 16:40:00 +0800
Message-ID: <CACVXFVMjf4HX7u4crzDsG7ix7sT0Mc=qT9s-X=tMf=VOKGs3ag@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
From: Ming Lei <ming.lei@canonical.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 4:22 PM, Oliver Neukum <oliver@neukum.org> wrote:
>
> OK, your trace is totally different. If your hangs are related, as is likely,
> my explanation goes out of the window.

If I run 'shutdown' after unplugging usb storage device, another hang trace
same with Alex's can be triggered too, so it should be one same problem.

Thanks,
--
Ming Lei
