Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaK3JCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 04:02:50 -0500
Received: from albireo.enyo.de ([46.237.207.196]:44377 "EHLO albireo.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaK3JCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 04:02:46 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: kdbus: add documentation
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
Date: Sun, 30 Nov 2014 10:02:32 +0100
In-Reply-To: <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	(Greg Kroah-Hartman's message of "Thu, 20 Nov 2014 21:02:17 -0800")
Message-ID: <871tolysbb.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Kroah-Hartman:

> +7.4 Receiving messages

> +Also, if the connection allowed for file descriptor to be passed
> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
> +installed into the receiving process after the KDBUS_CMD_MSG_RECV ioctl
> +returns. The receiving task is obliged to close all of them appropriately.

What happens if this is not possible because the file descriptor limit
of the processes would be exceeded?  EMFILE, and the message will not
be received?
