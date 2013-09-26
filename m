Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3IZQBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:01:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58756 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3IZQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:01:42 -0400
Date: Thu, 26 Sep 2013 18:01:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 3.12-rc1: i915 sudden black screen
Message-ID: <20130926160140.GA14924@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I got this in dmesg and lost my X session :-(.

									Pavel

shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-973650123
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1084569075
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1084569076
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-877153076
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-877153100
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-877153100
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-877153100
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-877153100
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-877153100
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1901714722
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1901714722
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1252071215
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-88207754
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-88207826
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1107866210
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1790402857
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-74531339
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1378730925
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1378730961
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1818703153
shrink_slab: i915_gem_inactive_scan+0x0/0xc0 negative objects to
delete nr=-1924308545
uhci_hcd 0000:00:1d.2: release dev 3 ep81-INT, period 8, phase 4, 93
us

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
