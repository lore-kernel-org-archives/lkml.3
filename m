Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3HGRfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:35:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44964 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3HGRfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:35:12 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: IDA/IDR rewrite, percpu ida
Date: Wed,  7 Aug 2013 10:34:55 -0700
Message-Id: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew - this should be pretty much identical to the patch series I
mailed out during last merge window, except rebased onto 3.11-rc4 and
retested.

I think the series should be more or less ready to go, and it'd be
really nice to get at least the percpu bits in - think you can have a
look and pick it up if it meets your standards?

Patch series is also available in git -
git://evilpiepirate.org/~kent/linux-bcache.git idr

