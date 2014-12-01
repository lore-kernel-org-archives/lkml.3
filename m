Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaLAOXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:23:44 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53232 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaLAOXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:23:43 -0500
Date: Mon, 1 Dec 2014 14:23:11 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Richard Yao <ryao@gentoo.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-api@vger.kernel.org
Subject: Re: Why not make kdbus use CUSE?
Message-ID: <20141201142311.37c81ff1@lxorguk.ukuu.org.uk>
In-Reply-To: <20141129063416.GE32286@woodpecker.gentoo.org>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> told quite plainly that such distributions are not worth consideration. If kdbus
> is merged despite concerns about security and backward compatibility, could we
> at least have the shim moved to libc netural place, like Linus' tree?

I would expect any other libc would fork the shim anyway (or just not
bother with systemd in most cases).

Alan
