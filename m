Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3G3Fw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:52:58 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64856 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3G3Fw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:52:56 -0400
Message-Id: <20130730055207.698660010@kernel.org>
User-Agent: quilt/0.50-1
Date: Tue, 30 Jul 2013 13:52:07 +0800
From: shli@kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, djbw@fb.com
Subject: [patch 0/3] raid5: make stripe handling multi-threading
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

This is another attempt to make raid5 stripe handling multi-threading.
Recent workqueue improvement for unbound workqueue looks very promising to the
raid5 usage. I had details in the first patch.

The patches are against your tree with patch 'raid5: make release_stripe
lockless' and 'raid5: fix stripe release order' but without 'raid5: create
multiple threads to handle stripes'

Thanks,
Shaohua
