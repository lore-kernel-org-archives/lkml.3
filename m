Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaINXOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 19:14:12 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49205 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaINXOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 19:14:11 -0400
Date: Mon, 15 Sep 2014 00:13:56 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/9 linux-next] drivers/gpu/drm: use container_of where
 possible
Message-ID: <20140915001356.2e05d782@alan.etchedpixels.co.uk>
In-Reply-To: <1410712823-29137-1-git-send-email-fabf@skynet.be>
References: <1410712823-29137-1-git-send-email-fabf@skynet.be>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2014 18:40:13 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> Small patchset using container_of instead of casting on first structure member address.

Why. Container_of is useful for random offsets but its just convoluting
and confusing code which is designed with the fields intentionally at the
start.

Alan
