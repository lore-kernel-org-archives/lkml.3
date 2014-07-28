Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaG1AL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 20:11:26 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:55647 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaG1ALX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 20:11:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Message-id: <fc0f860634c4.53d5952a@langara.bc.ca>
Date: Mon, 28 Jul 2014 00:11:22 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Bug 24912 - I think this one fell through the cracks a bit
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think that bug 2491 at
https://bugzilla.kernel.org/show_bug.cgi?id=24912 sort of fell through
the cracks and I'm not sure as many people are aware of it as there
could be. This bug is that one can't mount bind mounts readonly but
can only remount them readonly which is insufficient for recursive
bind mounts and certain kinds of sandboxing. Also the bind mount fails
silenty without giving an error which is never a good idea.
