Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab3FXIn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:43:56 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60879 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3FXIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:43:54 -0400
Message-ID: <1372063443.32157.10.camel@linux>
Subject: Per route MTU settings are broken in linux kernel 3.2
From: Yura Pakhuchiy <pakhuchiy@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 24 Jun 2013 15:44:03 +0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,

Looks like setting per route MTU (as described in [1]) is broken in
Linux kernel 3.2. I tested with newer Ubuntu kernels 3.5 and 3.8 and it
looks like problem is fixed there. I filled Ubuntu bug report [2] with
more details and sample script which illustrates problem. But since this
problem is probably also present in stock kernel (not just in Ubuntu),
is it possible to backport fixes to stable 3.2 series?

1. http://lartc.org/howto/lartc.cookbook.mtu-discovery.html
2. https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1177507

-- 
Best regards,
        Yura

