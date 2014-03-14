Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaCNRL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:11:58 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:59322 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaCNRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:11:56 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [RFC v3 0/3] Add aliases parsing to of_find_node_by_path()
Date: Fri, 14 Mar 2014 17:11:46 +0000
Message-Id: <1394817109-26199-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Searching for a node by path should also take into account an /aliases
reference. This series reworks the of_find_node_by_path() code to handle
that use-case easily. It also makes it possible to start a search at a
child node, which Pantelis needs for the FDT overlay work.

I've done some simple testing on this series, but it needs a lot more
attention and the testcases can use beefing up.

