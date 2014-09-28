Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaI1ChH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:37:07 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:59793 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaI1ChF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:37:05 -0400
Message-ID: <5427744E.4040409@gmail.com>
Date: Sat, 27 Sep 2014 22:37:02 -0400
From: nick <yocto6@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: khilman@deeprootsystems.com
CC: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Legacy Code in gpmc-onenand.c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Kevin and others,
I am wondering if the below code is legacy I can remove it as stated it the fix me.
Cheers Nick 
else {
                /*
                * FIX ME: Appears to be legacy code from initial ONENAND commit.
                * Unclear what boards this is for and if this can be removed.
                 */
                if (!cpu_is_omap34xx())
                        onenand_sync.wait_on_read = true;
        }
