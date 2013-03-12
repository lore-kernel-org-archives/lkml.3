Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab3CLPcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:32:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3CLPce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:32:34 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix eDP breakages on HP Z1 desktop
Date: Tue, 12 Mar 2013 16:32:26 +0100
Message-Id: <1363102348-16337-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a patch series to fix the breakages of eDP output on HP Z1
desktop machine with IvyBridge since 3.6 kernel.

The first patch is identical as what I already sent yesterday, reverting
a bogus check in the dp train loop.  The second one is the patch I cooked
today, for using the correct pixel clock for the fixed eDP panel.

I guess the second patch won't be applied cleanly to the old kernels,
so it'd need to be sent individually to stable kernel if needed.


thanks,

Takashi

