Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3HYKBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 06:01:42 -0400
Received: from mailfe07.tele2.at ([212.247.154.199]:38250 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756209Ab3HYKBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 06:01:41 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Aug 2013 06:01:41 EDT
X-T2-Spam-Status: No, hits=1.2 required=5.0 tests=MISSING_HEADERS
Date: Sun, 25 Aug 2013 11:53:55 +0200
From: David Oberhollenzer <david.oberhollenzer@tele2.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: prctl: Do not include linux/ptrace.h
Message-ID: <20130825115355.06636bf1@tele2.at>
In-Reply-To: <1377257869-23373-1-git-send-email-richard@nod.at>
References: <1377257869-23373-1-git-send-email-richard@nod.at>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: David Oberhollenzer <david.oberhollenzer@tele2.at>
