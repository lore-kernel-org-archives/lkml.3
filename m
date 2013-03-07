Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab3CGSvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:51:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759673Ab3CGSvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:51:16 -0500
From: Takashi Iwai <tiwai@suse.de>
To: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/3] blockconsole: make it a module
Date: Thu,  7 Mar 2013 19:51:04 +0100
Message-Id: <1362682267-10188-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <s5hk3pjm4it.wl%tiwai@suse.de>
References: <s5hk3pjm4it.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a patch series to allow to build the blockconsole as a module.
In a short test, it seems working somehow.  The module removal code is
a bit scary and there is much room for improvements / simplification.


thanks,

Takashi

