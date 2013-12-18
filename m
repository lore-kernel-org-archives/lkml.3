Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3LRAwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:52:39 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:42030 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3LRAwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:52:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw_C=U0BSb8b=SPiN-5b+=dT28_R7PKHrEyy-T+FeL0Ww@mail.gmail.com>
References: <alpine.DEB.2.00.1312180026340.10386@skynet.skynet.ie>
	<CA+55aFw_C=U0BSb8b=SPiN-5b+=dT28_R7PKHrEyy-T+FeL0Ww@mail.gmail.com>
Date: Wed, 18 Dec 2013 10:52:35 +1000
Message-ID: <CAPM=9tx7r5k6insqJbSJA_PeQJS2xpW85Gwnz0yjZ6OmsqX4Gw@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 10:42 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Dec 17, 2013 at 4:33 PM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> are available in the git repository at:
>>
>>   git://people.freedesktop.org/~airlied/linux
>
> Nope.
>
> I assume you meant the 'drm-fixes' branch, but you didn't actually
> *say* that, and when I pull it I don't get the same diffstat you
> claim, so I'm unpulling it and waiting for you to verify and
> double-check.
>

ouch, sorry - my push failed and then I failed, here's the correct one.

The following changes since commit 9538e10086bd1301fe915683b1ba0a1de66d7483:

  Merge git://www.linux-watchdog.org/linux-watchdog (2013-12-10 11:30:10 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 49d45a31b71d7d9da74485922bdb63faf3dc9684:

  drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook
(2013-12-17 14:18:16 +1000)

----------------------------------------------------------------
Alex Deucher (4):
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon/cik: plug in missing blit callback
      drm/radeon: add missing display tiling setup for oland
      Revert "drm/radeon: Implement radeon_pci_shutdown"

Ben Widawsky (7):
      drm/i915/bdw: Add BDW to ULT macro
      drm/i915/bdw: GEN8 backlight support
      drm/i915/bdw: Do gen6 style reset for gen8
      drm/i915/bdw: Free correct number of ppgtt pages
      drm/i915/bdw: Add comment about gen8 HWS PGA
      drm/i915/bdw: Limit GTT to 2GB
      drm/i915/bdw: PIPE_[BC] I[ME]R moved to powerwell

Chris Wilson (3):
      drm/i915: Do not clobber config status after a forced restore of hw state
      drm/i915: Hold mutex across i915_gem_release
      drm/i915: Repeat eviction search after idling the GPU

Christian König (1):
      drm/radeon: fix typo in cik_copy_dma

Daniel Vetter (3):
      drm/i915: fix pm init ordering
      drm/i915: Fix use-after-free in do_switch
      drm/i915: don't update the dri1 breadcrumb with modesetting

Dave Airlie (6):
      Merge branch 'bdw-fixes' of
git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge tag 'drm-intel-fixes-2013-12-11' of
git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-tda998x-3.12-fixes' of
git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-fixes
      Merge branch 'drm-fixes-3.13' of
git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'vmwgfx-fixes-3.13' of
git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge branch 'ttm-fixes-3.13' of
git://people.freedesktop.org/~thomash/linux into drm-next

Ilia Mirkin (2):
      drm: don't double-free on driver load error
      drm/nouveau: only runtime suspend by default in optimus configuration

Jakob Bornecrantz (1):
      drm/vmwgfx: Add max surface memory param

Martin Andersson (1):
      drm/radeon/dpm: Fix hwmon crash

Rafał Miłecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Russell King (4):
      DRM: Armada: implement lastclose() for fbhelper
      DRM: Armada: destroy framebuffer after helper
      DRM: Armada: fix printing of phys_addr_t/dma_addr_t
      DRM: Armada: prime refcounting bug fix

Thomas Hellstrom (1):
      drm/ttm: Fix accesses through vmas with only partial coverage

Ville Syrjälä (2):
      drm/i915: Take modeset locks around intel_modeset_setup_hw_state()
      drm/i915: Skip clock checks on BDW

 drivers/gpu/drm/armada/armada_drm.h     |  1 +
 drivers/gpu/drm/armada/armada_drv.c     |  7 ++++++-
 drivers/gpu/drm/armada/armada_fbdev.c   | 20 +++++++++++++++-----
 drivers/gpu/drm/armada/armada_gem.c     |  7 ++++---
 drivers/gpu/drm/drm_edid.c              |  8 ++++++++
 drivers/gpu/drm/drm_stub.c              |  6 +++---
 drivers/gpu/drm/i915/i915_dma.c         | 20 +++++++++++---------
 drivers/gpu/drm/i915/i915_drv.c         |  1 +
 drivers/gpu/drm/i915/i915_drv.h         |  9 ++++++---
 drivers/gpu/drm/i915/i915_gem_context.c | 16 ++++++++++++----
 drivers/gpu/drm/i915/i915_gem_evict.c   | 14 +++++++++++---
 drivers/gpu/drm/i915/i915_gem_gtt.c     |  9 +++++++--
 drivers/gpu/drm/i915/intel_display.c    |  7 ++++---
 drivers/gpu/drm/i915/intel_drv.h        |  1 +
 drivers/gpu/drm/i915/intel_panel.c      | 26 +++++++++++++++++++++++---
 drivers/gpu/drm/i915/intel_pm.c         | 29 +++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_ringbuffer.c |  1 +
 drivers/gpu/drm/i915/intel_uncore.c     |  1 +
 drivers/gpu/drm/nouveau/nouveau_drm.c   |  6 ++++++
 drivers/gpu/drm/radeon/atombios_crtc.c  |  4 +++-
 drivers/gpu/drm/radeon/cik_sdma.c       |  2 +-
 drivers/gpu/drm/radeon/radeon_asic.c    |  4 ++--
 drivers/gpu/drm/radeon/radeon_drv.c     | 10 ----------
 drivers/gpu/drm/radeon/radeon_pm.c      |  6 ++----
 drivers/gpu/drm/radeon/rs690.c          | 10 ++++++++++
 drivers/gpu/drm/ttm/ttm_bo_vm.c         |  6 +++---
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c   |  3 +++
 include/uapi/drm/vmwgfx_drm.h           |  1 +
 28 files changed, 173 insertions(+), 62 deletions(-)
