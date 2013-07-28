Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3G1SsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:48:11 -0400
Received: from mail-vc0-f193.google.com ([209.85.220.193]:37541 "EHLO
	mail-vc0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3G1SsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:48:09 -0400
MIME-Version: 1.0
Date: Sun, 28 Jul 2013 14:48:09 -0400
Message-ID: <CALHgxMEtcdkmrwnu8+mAhUOAMQz7B3V7J01sChF7x3-QQsRcBw@mail.gmail.com>
Subject: write(2) and page cache
From: dmi p <d3vp0ll@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
When I write(2) on a file such that the size of the buffer being
written is less than the page size, and the page is not in the page
cache, does the write syscall block until the page is brought into the
page cache from disk (to modify it and eventually write back), or is
the page reading part async with respect to write?
