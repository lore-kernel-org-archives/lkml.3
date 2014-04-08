Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbaDHOcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:32:48 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:59263 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033AbaDHOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:32:47 -0400
Message-ID: <1396967565.24714.6.camel@x220>
Subject: Re: [PATCH] initramfs: remove "compression mode" choice
From: Paul Bolle <pebolle@tiscali.nl>
To: "Prasad J. Pandit" <ppandit@redhat.com>
Cc: Hristo Venev <hristo@venev.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 16:32:45 +0200
In-Reply-To: <alpine.LFD.2.10.1404081851490.29689@wniryva.cad.erqung.pbz>
References: <1396958857.26620.35.camel@x220>
	 <alpine.LFD.2.10.1404081851490.29689@wniryva.cad.erqung.pbz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2014 14:32:45.0736 (UTC) FILETIME=[686DB280:01CF5337]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 18:59 +0530, P J P wrote:
> +-- On Tue, 8 Apr 2014, Paul Bolle wrote --+
> | "Built-in initramfs compression mode" choice is a set of knobs connected
> | to nothing. The entire choice can safely be removed.

>    This patch has already been submitted upstream; though not sure if it is 
> merged yet.

Not in mainline or linux-next.

> Please see -> https://lkml.org/lkml/2013/11/25/21
> 
> @Andrew: is it queued to be merged upstream?

lkml.org shows nothing for me, currently, but I think it's the same one as
http://marc.info/?l=linux-kernel&m=138536209816822&w=2 . Though I think
the commit explanation of my patch is clearer I'm fine with Hristo's
patch. And that patch also predates mine by five months. 

Thanks,


Paul Bolle

