Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaFXMhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:37:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48676 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:37:07 -0400
Date: Tue, 24 Jun 2014 13:36:11 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Alan, can you revisit a patch you authored please?
Message-ID: <20140624133611.62e4c3b7@alan.etchedpixels.co.uk>
In-Reply-To: <20140623085345.GD8847@lee--X1>
References: <20140623085345.GD8847@lee--X1>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 09:53:45 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> Hi Alan,
> 
> I'm looking at a patch you wrote which can be foudn below at [1].  Are
> you sure it's correct to ignore i.e not return -ENOMEM from
> platform_device_add_data() in pcf50633_probe()?  I believe if
> platform_device_add_data() returns an error we should
> platform_device_put() and return immediately.  Can you tell me if you
> agree.  If you don't, would you mind explaining to me why please?

I made the change to maximise the chance of things booting up ok, but I
agree, its a pointless exercise. If we fail to add the data we should
just chuck it.

Alan
