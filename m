Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaFGSqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 14:46:19 -0400
Received: from zill.ext.symas.net ([69.43.206.106]:40704 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaFGSqR (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Sat, 7 Jun 2014 14:46:17 -0400
X-Greylist: delayed 2289 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2014 14:46:17 EDT
Message-ID: <53935504.1080903@symas.com>
Date: Sat, 07 Jun 2014 11:08:04 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26a1
MIME-Version: 1.0
To: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: 3.12.9 kern.log spam from vgaswitcheroo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Asus NP56D, if you use vgaswitcheroo to turn off the discrete GPU, the 
kernel starts spewing these messages endlessly, until /var/log partition fills up:

Jun  7 17:40:27 gamba kernel: [470008.702322] [drm:radeon_cs_parser_init] 
*ERROR* VM not ac
tive on asic!
Jun  7 17:40:27 gamba kernel: [470008.702325] [drm:radeon_cs_ioctl] *ERROR* 
Failed to initi
alize parser !
Jun  7 17:40:27 gamba kernel: [470008.702385] [drm:radeon_cs_parser_init] 
*ERROR* VM not ac
tive on asic!
Jun  7 17:40:27 gamba kernel: [470008.702389] [drm:radeon_cs_ioctl] *ERROR* 
Failed to initi
alize parser !

Turning the discrete GPU back on stops the stream of messages.
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
