Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaG2Vz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:55:59 -0400
Received: from message.mylangara.bc.ca ([142.35.159.25]:37598 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaG2Vz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:55:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, mtk@man7.org
Message-id: <fb82d1d46d8f.53d8186c@langara.bc.ca>
Date: Tue, 29 Jul 2014 21:55:56 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Does anyone know when FUTEX_WAIT can fail with EAGAIN?
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to debug a hangup where my program loops with FUTEX_WAIT (actually
FUTEX_WAIT_PRIVATE but same thing)  endlessly erring out with EAGAIN. I would
like to know if anyone on the mailing list knows when FUTEX_WAIT can fail with
EAGAIN.

Some info for people who are interested in what I'm working on.

I'm working on sand boxing my program at gitorious.org/linted with namespaces
and chroot.

The error only appeared after changing unshare then fork code into a direct
clone call.

> | uname -a
> Linux alonzo 3.13.0-24-generic #1trisquel1 SMP Tue May 13 15:17:50 UTC 2014
x86_64 x86_64 x86_64 GNU/Linux

Thank you,
Steven Stewart-Gallus
