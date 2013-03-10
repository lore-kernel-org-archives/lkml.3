Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3CJPa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:30:27 -0400
Received: from www17.your-server.de ([213.133.104.17]:35443 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3CJPa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:30:26 -0400
Message-ID: <1362929420.1220.11.camel@localhost.localdomain>
Subject: lock() -> Where is this defined?
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Mar 2013 16:30:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in include/linux/lockdep.h:

#define LOCK_CONTENDED(_lock, try, lock) \
    lock(_lock)

Where is this lock() function defined?



