Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab3HTQPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:15:20 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57659 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3HTQPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:15:18 -0400
Subject: [PATCH v3 trivial 0/7] Miscellaneous Trivialities
Date: Tue, 20 Aug 2013 16:02:42 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been sitting on some trivial patches for a while, and I'd just
like to get them out of the way.

Here is the series:

  [1] Docs: Kconfig: For readability, offset modifiers with commas
  [2] Docs: Kconfig: Use consistent whitespace indentation
  [3] Docs: Kconfig: Clean up the radiotap documentation
  [4] Docs: Kconfig: `devlopers' -> `developers'
  [5] DRM: comment: `halve' -> `half'
  [6] DRM: comment: `gdm_proc_lists' -> `drm_info_lists'
  [7] DRM: cleanup: Remove unused `gamma_size'

  drivers/gpu/drm/drm_fb_helper.c      |   3 --
  drivers/gpu/drm/drm_irq.c            |   4 +-
  drivers/gpu/drm/drm_proc.c           |   2 +-
  drivers/net/wireless/ipw2x00/Kconfig | 102 +++++++++++++++++------------------
  fs/btrfs/Kconfig                     |   3 +-
  init/Kconfig                         |   4 +-
  6 files changed, 58 insertions(+), 60 deletions(-)

Each patch is provided in an email, but you may pull from the
following:

  https://github.com/mfwitten/linux.git trivial/misc/3

which is the result of applying these patches to commit
b36f4be3de1b123d8601de062e7dbfc904f305fb (Linux 3.11-rc6).
-- 
1.7.11.2.252.gc4a64c8

