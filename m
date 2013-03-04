Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3CDOHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:07:09 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34751 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3CDOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:07:07 -0500
Date: Mon, 4 Mar 2013 22:07:00 +0800
From: Zach Pfeffer <zach.pfeffer@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2013 Android Microconference at Linux Plumbers: Call for
 Participation
Message-ID: <20130304140700.GB11031@zach-linaro-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's interest in having an Android microconference at this year's Linux Plumbers Conference. I've started a Wiki at:

http://wiki.linuxplumbersconf.org/2013:android

I'd like to invite people to add topics to the Wiki. Please include a description of the topic you'd like to discuss. In general, topics that present work to close the gap between the mainstream kernel and the Android kernel are preferred as well as topics for future mechanisms that may be needed by Android and other mobile usecases. In addition, topics related to successful out-of-tree patch maintenance and challenges in commercialization would also be useful.

Most of the big pain points people are seeing are related to buffer passing and synchronization for that reason it was thought that the following topics may be good to discuss:

dmabuf fences / sync
unified in-kernel IPC
ION/dmabuf/Common Display Framework

I've listed these on the Wiki to get things started.
