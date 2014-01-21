Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaAUNuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:50:13 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60824 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaAUNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:50:09 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/3] scripts/dtc: Update to latest released mainline
Date: Tue, 21 Jan 2014 13:49:58 +0000
Message-Id: <1390312201-22754-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple series to update dtc to the latest mainline release (v1.4.0) and
add a script that automates the process of upgrading dtc.

