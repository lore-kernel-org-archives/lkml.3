Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3A2TIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:08:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab3A2TIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:08:50 -0500
Date: Tue, 29 Jan 2013 20:07:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Lingzhu Xiang <lxiang@redhat.com>, Roman Rakus <rrakus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] tty: set_termios/set_termiox should not return -EINTR
Message-ID: <20130129190720.GA28000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The patch looks really trivial and I even cc'ed -stable.

But it needs the review from someone who understands the drivers/tty
code, perhaps there is a reason why we should not restart TCGETA/etc.
I do not even know what set_termios() actually does ;)

Oleg.

