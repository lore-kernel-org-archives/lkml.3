Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbbAKX6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:58:17 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47157 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbbAKX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:58:16 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: linux-doc@vger.kernel.org
Cc: Julian Brost <linux-kernel@0x4a42.net>, linux-kernel@vger.kernel.org,
        corbet@lwn.net, tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: [PATCH 0/4] Documentation/misc-devices/mei: Fix formatting
Date: Mon, 12 Jan 2015 00:58:05 +0100
Message-Id: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes multiple formatting issues in the documentation for the
Intel MEI, including improperly formatted headlines and issues with spacing and
indentation.

Julian Brost (4):
  Documentation/misc-devices/mei: Fix formatting of headings.
  Documentation/misc-devices/mei: Fix spacing around parentheses.
  Documentation/misc-devices/mei: Fix indentation of enumeration.
  Documentation/misc-devices/mei: Fix indentation of embedded code.

 Documentation/misc-devices/mei/mei-client-bus.txt |  17 +--
 Documentation/misc-devices/mei/mei.txt            | 126 ++++++++++++----------
 2 files changed, 77 insertions(+), 66 deletions(-)

-- 
2.2.1

