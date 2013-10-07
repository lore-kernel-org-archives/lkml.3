Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3JGRxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:53:36 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58122 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3JGRxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:53:33 -0400
MIME-Version: 1.0
Date: Mon, 7 Oct 2013 10:53:32 -0700
Message-ID: <CAOMFOmWbvLCM=a2n_ojnWVeeyvMg=v1T03Q44q-q4jgR7sH+DA@mail.gmail.com>
Subject: mm: Export 'pageflag_names' array
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>
Cc: gthelen@google.com, Dave Anderson <anderson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu

I have a request wrt your old commit 718a38211.

I think it makes sense to export array pageflag_names so kernel dump
debug tools (like 'crash') can use it as well. Currently the tool
hard-codes flag names but it is suboptimal as flags are different for
different configs.

What do you think? (I can send a patch if you are ok).
