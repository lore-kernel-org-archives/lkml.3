Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3GJBqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:46:07 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53467 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3GJBqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:46:06 -0400
MIME-Version: 1.0
Date: Wed, 10 Jul 2013 11:46:03 +1000
Message-ID: <CAPM=9tzTUuOjmicjKs+OWirLz6+oHKJgnHjKHAd7WLv8JGmKCA@mail.gmail.com>
Subject: virtio indirect with lots of descriptors
From: Dave Airlie <airlied@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

playing with my virtio gpu, I started hitting the qemu
error_report("Too many read descriptors in indirect table");

Now I'm not sure but this doesn't seem to be a virtio limit that the
guest catches from what I can see, since my host dies quite quickly,
when I'm doing transfers in/out of a 5MB object with an sg entry per
page.

Just wondering if you can confirm if this is only a qemu limitation or
if I should just work around it at a bit of a higher level in my
driver/device?

Dave.
