Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaHJV6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 17:58:12 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:51347 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbaHJV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 17:58:11 -0400
From: =?utf-8?B?56mN5Li55bC8?= Dan Jacobson <jidanni@jidanni.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: disable "Call Trace:"
References: <877g2jznnt.fsf@jidanni.org>
Date: Mon, 11 Aug 2014 05:58:07 +0800
Message-ID: <87zjfcxb0w.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another one I saw occupying the screen:

[...] ---[ end trace ... ]---
[...] Fixing recursive fault but reboot is needed!

Make sure that the user can also turn that one off and run it again to
reveal the messages that were pushed off the screen above it.
