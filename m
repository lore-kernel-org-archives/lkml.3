Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3AaKO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:14:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab3AaKO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:14:26 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] firmware: Make user-mode helper optional (v5)
Date: Thu, 31 Jan 2013 11:13:53 +0100
Message-Id: <1359627237-7069-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series of revised patches for making the user-mode helper
call in the firmware loader optional.  Hopefully all things settled
down now.

v4->v5: fix invalid call of usermodehelper_unlock()


thanks,

Takashi

