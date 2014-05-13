Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969AbaEMO6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:58:45 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39414 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459AbaEMO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:58:41 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/3] Rework of_find_node_by_path() code
Date: Tue, 13 May 2014 15:58:32 +0100
Message-Id: <1399993115-21552-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series reworks the of_find_node_by_path() function to search by
path component instead of comparing the full path on every node. This
makes for a more efficient search and makes it possible to parse things
like aliases.

This is the second time I'm posting this series. I'm going to apply it
to my tree for the next merge window.

