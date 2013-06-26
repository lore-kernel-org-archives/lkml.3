Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3FZIf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:35:58 -0400
Received: from vps1.hno.se ([31.192.227.87]:44482 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3FZIf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:35:56 -0400
Message-ID: <1372235738.17654.2.camel@localhost>
Subject: Re: openrisc: call do_notify_resume() with interrupts enabled
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Date: Wed, 26 Jun 2013 10:35:38 +0200
In-Reply-To: <1367219557-11495-1-git-send-email-stefan.kristiansson@saunalahti.fi>
References: <1367219557-11495-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mån 2013-04-29 klockan 10:12 +0300 skrev Stefan Kristiansson:
> A signal delivered through do_notify_resume() would cause the
> irqs_disabled() check in _local_bh_enable_ip() to be triggered.
> 
> Enable interrupts before calling do_notify_resume().
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

Tested-by: Henrik Nordstrom <henrik@henriknordstrom.net>

Regards
Henrik

