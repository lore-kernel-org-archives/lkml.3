Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3GCVVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:21:17 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40076 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab3GCVVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:21:16 -0400
Subject: [problem?] swapon: swap partition/volume size capped at 32G?
From: Raymond Jennings <shentino@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Jul 2013 14:21:13 -0700
Message-ID: <1372886473.1079.3.camel@warfang>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so I just upgraded to 3.10.0 (gentoo system) and made a nice big
64GiB swap volume on lvm as usual.

Suddenly, swapon doesn't recognize more than 32GiB, as top lists only
that much swap space.

swapon using *two* separate 32GiB partitions works fine, but for some
reason a swap partition bigger than 32GiB isn't fully recognized.

Previous kernel versions IIRC recognized the entire swap partition.

Is something wrong or is this new behavior standard?

