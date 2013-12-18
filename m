Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3LRXzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:55:37 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47024 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3LRXzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:55:36 -0500
Date: Wed, 18 Dec 2013 23:55:26 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2] misc: Reserve minor for VFIO
Message-ID: <20131218235526.4b4388d4@alan.etchedpixels.co.uk>
In-Reply-To: <52B21B7E.1020307@zytor.com>
References: <20131218204024.30540.55302.stgit@bling.home>
	<20131218210141.GA11267@kroah.com>
	<52B21B7E.1020307@zytor.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think Alan Cox was the last person to man <device@lanana.org>... Alan,
> are you still doing that?  (Otherwise patching the file in the Linux
> kernel tree seems eminently sensible... there really isn't any need to
> reserve numbers for out-of-tree drivers anymore.  Just another perk of
> being in-tree.)

I am sort of but the mail alias hasn't worked for a long time afaik.

>From the records I have 196 was never issued to anything in tree or
mainstream in recent history so lets make it official ?
