Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408Ab3EAOrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab3EAOqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:46:52 -0400
Message-ID: <51812AD8.1000804@redhat.com>
Date: Wed, 01 May 2013 11:46:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.10-rc1] omap3isp generic clock
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/omap3isp

for a  patch that makes omap3isp to use the generic clock framework.

This patch were sent in separate as it depends on a merge from clock
framework, that you merged on changeset 362ed48dee509abe24cf84b7e137c7a29a8f4d2d.

Thanks!
Mauro

-

The following changes since commit 4290fd1a5688f3510caa0625c62d73de568ed2c2:

   [media] MAINTAINERS: Mark the SH VOU driver as Odd Fixes (2013-04-14 20:15:55 -0300)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/omap3isp

for you to fetch changes up to 9b28ee3c9122cea62f2db02f5bb1e1606bb343a6:

   [media] omap3isp: Use the common clock framework (2013-04-14 20:21:12 -0300)

----------------------------------------------------------------
Laurent Pinchart (1):
       [media] omap3isp: Use the common clock framework

  drivers/media/platform/omap3isp/isp.c | 277 +++++++++++++++++++++++++---------
  drivers/media/platform/omap3isp/isp.h |  22 ++-
  include/media/omap3isp.h              |  10 +-
  3 files changed, 225 insertions(+), 84 deletions(-)

