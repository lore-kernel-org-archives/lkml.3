Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbbACO34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 09:29:56 -0500
Received: from smtp1.hushmail.com ([65.39.178.135]:48504 "EHLO
	smtp1.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbbACO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 09:29:55 -0500
X-Greylist: delayed 2254 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jan 2015 09:29:55 EST
MIME-Version: 1.0
Date: Sat, 03 Jan 2015 14:52:20 +0100
To: linux-kernel@vger.kernel.org
Subject: PVS-Studio static analysis of v3.18.1
From: hg1skz6k3@hush.ai
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20150103135220.5E4F160191@smtp.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PVS-Studio people used their static analizer on v3.18.1,
and claim that they are not familiar with the kernel but have found issues,
some of which may or may not be potential vulnerabilities.

This article is essentially an ad, but still interesting
http://www.viva64.com/en/b/0299/

