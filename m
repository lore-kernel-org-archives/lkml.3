Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaFZVft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:35:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52410 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaFZVfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:35:48 -0400
Date: Thu, 26 Jun 2014 22:35:33 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tomasz Torcz <tomek@pipebreaker.pl>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] vt: disable console blanking by default
Message-ID: <20140626223533.11c17877@alan.etchedpixels.co.uk>
In-Reply-To: <201406252121.38263.a.miskiewicz@gmail.com>
References: <20140618092730.GD22226@mother.pipebreaker.pl>
	<20140625133930.223cccb5@alan.etchedpixels.co.uk>
	<201406252121.38263.a.miskiewicz@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 3. unblank & disable blanking on any oops? (probably problematic)

We already try to do that.

Alan
