Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3CSIoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:44:34 -0400
Received: from sauhun.de ([89.238.76.85]:53423 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab3CSIoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:44:32 -0400
Date: Tue, 19 Mar 2013 09:44:52 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Current I2C workflow
Message-ID: <20130319084442.GA3170@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

working on the transparency thing here regarding the current I2C
workflow. I am currently on, well, let's call it something between
holiday and retreat. I will work on (hopefully all) pending I2C patches
half-time until Friday and then probably disappear for about 3 weeks
again. Disappearing means I will lurk the list for urgent patches and
handle them, but will pass the other ones for later handling. So, please
make sure to emphasize urgent patches.

For a few weeks now, the I2C list is monitored by patchwork [1] (Thanks,
Jeremy!), which should make sure that no patches are forgotten. I do use
the status field, so this list is a good place to check if you wonder
what happened to your patch. I will send replies explaining my
decisions, nonetheless.

People reviewing patches from each other are much appreciated and will
help the process.

And to make clear after some email confusion: wsa@the-dreams.de is the
preferred email address for my kernel related stuff.

Off to work,

   Wolfram

[1] http://patchwork.ozlabs.org/project/linux-i2c/list/
