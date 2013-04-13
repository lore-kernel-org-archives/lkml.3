Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3DML1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 07:27:16 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:43479 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3DML1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 07:27:15 -0400
Message-ID: <5169410A.8050602@xs4all.nl>
Date: Sat, 13 Apr 2013 13:27:06 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.8.5: incorrect semaphore state issue
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This morning I did a luksOpen on an external harddisk and saw:

# cryptsetup luksOpen /dev/sde1 crypto2
Enter passphrase for /dev/sde1:
semid 557063: semop failed for cookie 0xd4dd6db: incorrect semaphore state
Failed to set a proper state for notification semaphore identified by
cookie value 223205083 (0xd4dd6db) to initialize waiting for incoming
notifications.
# mount /dev/mapper/crypto2 /media
#

So stuff worked OK, just the unexpected messages.
I did find an ubuntu bug from 2011 so what needs fixing this time?

Please advise!

Kind regards,
Udo
