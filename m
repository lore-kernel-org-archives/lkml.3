Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3J3JPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:15:06 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:54787 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab3J3JPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:15:04 -0400
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:15:04 +0400
Message-ID: <CAMQ79Xm2gwURrctVZOChs8CqeTxxkvsCmELH9oh5KaXq3QsxqA@mail.gmail.com>
Subject: routing rule with additional attributes (RTA_DST)
From: =?KOI8-R?B?98HTyczJyiDtwcvTyc3P1w==?= <vasilii.maksimov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

while cretaing rules via NETLINK, I observed not (well) documented in
rtnetlink(7) behaviour.

If I created rule using RTM_NEWRULE message, I'm able to provide
RTA_DST attribute with destination IP (setting up rtmsg.dst_len to the
appropriate value).
Such message to NETLINK provides to creating following rules:
#ip ru sh
...
19999: from 10.0.0.1 to 10.10.0.11 lookup 19
...

So, could you please tell:
-can I count on this behaviour in future linux kernels?
-which additional attributes can be also passed? I tried
RTA_IIF/RTA_OIF and it looks like it works too.
-is there any way to debug how kernel choose rules?

Thanks in advance,
Vasily.
