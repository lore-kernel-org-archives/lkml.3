Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaBRWb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:31:29 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51067 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBRWb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:31:28 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Bug fix and test matching method for of_match_node()
Date: Tue, 18 Feb 2014 22:31:16 +0000
Message-Id: <1392762680-1498-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes the matching order in of_match_node() and adds some
test cases to make sure the ordering is working correctly. It mostly
works, but there is one test case that fails. I haven't debugged yet
whether the problem is of_match_node() or the testcase itself.

