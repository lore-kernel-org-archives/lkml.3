Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaBRF0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 00:26:12 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:38279 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaBRF0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 00:26:11 -0500
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>
Subject: [PATCH 0/2] Fix missing misc nodes
Date: Tue, 18 Feb 2014 02:27:23 -0300
Message-Id: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

These patches are not intended for merging as is... clearly we have at least
one problem: fram's minor is clashing with logibm's. I don't know what to do
here.

The first patch also adds comments on those minors that are defined but not
used. Is that ok?

Lucas De Marchi (2):
  misc: add comment on unused minors
  misc: add missing minor nodes

 Documentation/devices.txt  |  3 +++
 include/linux/miscdevice.h | 16 ++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
1.9.0

