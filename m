Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3CNLB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:01:57 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64366 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab3CNLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:01:55 -0400
Message-ID: <5141AE1F.40308@suse.cz>
Date: Thu, 14 Mar 2013 12:01:51 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: stable <stable@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [stable request] TTY: do not reset master's packet mode
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please include the patch below to all maintained stable trees.

commit b81273a132177edd806476b953f6afeb17b786d5
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Tue Jan 15 23:26:22 2013 +0100

    TTY: do not reset master's packet mode

thanks,
-- 
js
suse labs
