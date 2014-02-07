Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaBGVXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:23:47 -0500
Received: from forward20.mail.yandex.net ([95.108.253.145]:51396 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaBGVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:23:46 -0500
From: zbr@ioremap.net
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140207055832.GN5342@spacedout.fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
 <9071391471978@web15j.yandex.ru>
 <20140204055131.GI5342@spacedout.fries.net>
 <253061391557725@web20g.yandex.ru> <20140207055832.GN5342@spacedout.fries.net>
Subject: Re: [PATCH 0/4] w1: refcnt fix, skip non-error send, docs
MIME-Version: 1.0
Message-Id: <7611391808223@web21g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 08 Feb 2014 01:23:43 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

07.02.2014, 10:00, "David Fries" <david@fries.net>:

> Here's a patch to implement that. šIs this what you have in mind?
>
> From 4ed65d81b0121a8c191a9833d041484e9097198b Mon Sep 17 00:00:00 2001
> From: David Fries <David@Fries.net>
> Date: Thu, 6 Feb 2014 23:45:05 -0600
> Subject: [PATCH] w1: correct cn_msg ack, no change or seq + 1
>
> Netlink messages sent from the kernel consists of kernel generated
> notifications for adds or removes, the error message (also indicates
> the message has been processed), and the messages that have data to
> return. šThe cn_msg ack is left alone for the first two, and when
> returning data it is the sequence number + 1. šModifying the code to
> the protocol standard.
>
> Signed-off-by: David Fries <David@Fries.net>

Yes, it looks right.
Can you also check that protocol documentation is correct?
