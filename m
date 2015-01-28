Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbbA2Blq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:41:46 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59349 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbbA2Bln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:43 -0500
MBOX-Line: From nobody Wed Jan 28 16:49:36 2015
Subject: Documentation: DT bindings: update DT binding docs with Tegra chips
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 16:49:36 -0700
Message-ID: <20150128234935.20644.89300.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update some of the DT binding documentation text files, per Mark's
comments at:

http://marc.info/?l=linux-tegra&m=142201349727836&w=2

The primary goal with this series is to avoid checkpatch.pl warnings
and align to the policy that Mark described.  This series also updates
Documentation/devicetree/bindings/submitting-patches.txt to formally
document this policy.

These patches apply on next-20150123.


- Paul

