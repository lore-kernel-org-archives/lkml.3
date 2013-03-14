Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3CNUeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:34:13 -0400
Received: from mail.wdtv.com ([66.118.69.84]:50469 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab3CNUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:34:12 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Nouveau q?
Date: Thu, 14 Mar 2013 16:34:06 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303141634.06646.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;  I haven't built a kernel in half a coons age, so I thought I'd 
try.  Currently running 2.6.32-122-rtai, with the nouveau driver on this 
video card:
VGA compatible controller: nVidia Corporation G96 [GeForce 9400 GT] (rev 
a1)

While configuring, I noted some WMI (don't run winderz, don't even have a 
windows box on in the property) options & turned them off, but that 
generates complaints from the make:

warning: (DRM_NOUVEAU) selects ACPI_WMI which has unmet direct dependencies 
(X86 && X86_PLATFORM_DEVICES && ACPI)

warning: (DRM_NOUVEAU) selects MXM_WMI which has unmet direct dependencies 
(X86 && X86_PLATFORM_DEVICES && ACPI_WMI)

I'll go back and turn them on, which should not be a problem other than the 
wasted build time measured in hours on this machine, a quad core phenom.  
Can the make configs turn this back on automatically?

Thanks.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
My views 
<http://www.armchairpatriot.com/What%20Has%20America%20Become.shtml>
Consultant, n.:
	An ordinary man a long way from home.
I was taught to respect my elders, but its getting 
harder and harder to find any...
