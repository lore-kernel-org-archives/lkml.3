Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3LZRir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 12:38:47 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:41712 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3LZRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 12:38:45 -0500
Message-ID: <52BC698A.9030805@ahsoftware.de>
Date: Thu, 26 Dec 2013 18:38:18 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: What does echo -c do (as found in dynamic-debug-howto.txt)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just read Documentation/dynamic-debug-howto.txt (again) and I 
wonder what the parameter -c for echo is for (found at lines 94 ff).

Neither echo from coreutils nor the buildin from bash do know the 
parameter -c.

The paragraph which made me curious starts with

-----
Command Language Reference
==========================

At the lexical level, a command comprises a sequence of words separated
by spaces or tabs.  So these are all equivalent:

nullarbor:~ # echo -c 'file svcsock.c line 1603 +p' >
                                 <debugfs>/dynamic_debug/control
nullarbor:~ # echo -c '  file   svcsock.c     line  1603 +p  ' >
                                 <debugfs>/dynamic_debug/control
nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
                                 <debugfs>/dynamic_debug/control
-----

Is that -c a parameter for a buildin echo of one of the various shells, 
a typo (looks unlikely) or do I miss something else which make me look a 
noob?

Regards,

Alexander Holler
