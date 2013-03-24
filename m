Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3CXVat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:30:49 -0400
Received: from smtp2.ispfabriek.nl ([188.142.0.19]:47599 "EHLO
	smtp2.ispfabriek.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3CXVas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:30:48 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Mar 2013 17:30:48 EDT
Message-ID: <514F6DF9.1070602@xmsnet.nl>
Date: Sun, 24 Mar 2013 22:19:53 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121030 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: regression: grass turns red
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 49cb25e9290 x86: 'get rid of pt_regs argument in vm86/vm86old' 
somehow breaks the colors when I play 'civilization I' under xdosemu. 
During the intro of the game something the colors get messed up. When 
the game begins the grass of the earth is red. Reverting the  commit 
fixes the problem.

-- 
Hans
