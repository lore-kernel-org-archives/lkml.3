Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaIQKtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:49:33 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:56863 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaIQKtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:49:32 -0400
Date: Wed, 17 Sep 2014 11:49:16 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, peter@hurleysoftware.com
Subject: Re: [PATCH 0/9 linux-next] drivers/gpu/drm: use container_of where
 possible
Message-ID: <20140917114916.1c0928c2@alan.etchedpixels.co.uk>
In-Reply-To: <1669797975.16695.1410804954304.open-xchange@webmail.nmp.skynet.be>
References: <1410712823-29137-1-git-send-email-fabf@skynet.be>
	<20140915001356.2e05d782@alan.etchedpixels.co.uk>
	<1669797975.16695.1410804954304.open-xchange@webmail.nmp.skynet.be>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What if someone doesn't know about that intention one day and inserts
> some field in the structure at the "wrong place" ?

Then we have code review. Also they are much more likely to simply change
the code elsewhere and break it. Nobody afaik ever got this wrong, while
the litany of other broken patches and bugs introduced into the same code
is lagre.

The goal of the kernel is not to be foolproof to developer incompetence -
that's a battle you can't win until you replace driver developers with
software systems.

Alan
