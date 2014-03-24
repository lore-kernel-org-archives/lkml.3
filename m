Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaCXOQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:16:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47891 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaCXOQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:16:12 -0400
Date: Mon, 24 Mar 2014 14:15:58 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "David F." <df7729@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: patch fix for intel sdd s3500 series on Sil3512 controller
Message-ID: <20140324141558.31c169cf@alan.etchedpixels.co.uk>
In-Reply-To: <CAGRSmLtifL=hFBP1AUHB_va6ZvNfqXo8Bu=6XciH--jOEYVJjQ@mail.gmail.com>
References: <CAGRSmLtifL=hFBP1AUHB_va6ZvNfqXo8Bu=6XciH--jOEYVJjQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014 16:32:54 -0700
"David F." <df7729@gmail.com> wrote:

> Hi,
> 
> It appears if nIEN is set all polling type IO fails.   After an
> attempt, future non-polled communications also fails.  This patch
> allows it to work.  Not sure if any spin lock protection would be
> needed or the system already handles the device existence for the
> generated irq with polling enabled.  handler already ignored irq if
> queued command was polling type.

Does it behave plugged into a different controller without the hacks ?

Alan

