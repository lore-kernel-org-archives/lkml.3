Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972AbaDOQF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:05:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44999 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaDOQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:05:28 -0400
Date: Tue, 15 Apr 2014 17:05:19 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][4/11][MANUX] Kernel compatibility : ioctl(2)
Message-ID: <20140415170519.75d885fb@alan.etchedpixels.co.uk>
In-Reply-To: <534D5795.8080100@manux.info>
References: <534D375E.7070308@manux.info>
	<20140415160035.3135dda7@alan.etchedpixels.co.uk>
	<534D5795.8080100@manux.info>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this is an unproblematic extension, especially since these
> ioctls are only supposed to be called by low-level software shipped with
> the OS.

Thats the excuse everyone gives for messing up standards stuff. It
usually comes back to bite you later.

If it's not ioctl don't call it ioctl, have a fdoctl() or something

Alan
