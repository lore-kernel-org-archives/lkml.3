Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbaJUPyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:54:23 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57810 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbaJUPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <E1XgbTy-00072R-N3@feisty.vs19.net>
References: <E1XgbTy-00072R-N3@feisty.vs19.net>
Date: Tue, 21 Oct 2014 17:48:10 +0200
Message-ID: <CAA7pwKODrr7g=u75ALujrVHq5cXNsAf=QtGVCh+rKCrqd7UKUg@mail.gmail.com>
Subject: Re:
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bastien Nocera <hadess@hadess.net>, Sergey <sergey@elementaryos.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien Nocera wrote:
> I've posted this list at:
> https://wiki.gnome.org/BastienNocera/KernelWishlist

I think what you want from epoll_wait() can be done with timerfd.
