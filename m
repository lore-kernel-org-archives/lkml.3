Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3C1Ppw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:45:52 -0400
Received: from plane.gmane.org ([80.91.229.3]:58266 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab3C1Ppt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:45:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: drm/radeon: continued dead graphics with X on Thinkpad T60 with kernel 3.8.x/3.9.x
Date: Thu, 28 Mar 2013 16:45:32 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2013.03.28.15.45.32.586480@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5487679d.dip.t-dialin.net
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My old trusty Thinkpad T60 with a Mobility Radeon X1400 runs fine with
3.7.10 - glxgears, vlc work great. However with kernel >=3.8.x any attempt
at X dies in various ways. While waiting for all the other regressions in
3.8.x to settle down I've collected the occasional attempt with newer
kernels. As even latest 3.8.5 and 3.9-rc2 are affected (the two failing
almost identically) I figured it is about time I complain. :)

Captured logs with annotations and oopses are at:
http://hoho.dyndns.org/linux/radeon/, including as much relevant info as I
could collect. All kernels are built the same way (via genkernel, an
automated script) and configurations between kernel versions have not been
altered. The 3.7.10 log is just included for reference (maybe the HW
is initialized differently?); the system is rock-stable otherwise.

I can gladly help track this down/build/patch from git but need some
pointers how to proceed. 3.7.10 is the last kernel that works (very well)
but is unmaintained, and it would be nice to move on to 3.8.5 to benefit
from ongoing bug fixes.

thanks!
Holger


