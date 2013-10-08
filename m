Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3JHJDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:03:23 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36014 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3JHJCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:02:39 -0400
Message-Id: <20131008090019.527108154@gmail.com>
User-Agent: quilt/0.60-1
Date: Tue, 08 Oct 2013 13:00:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] Soft dirty tracking fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! Here is a couple of fixes for soft dirty pages tracking.
While first two patches are adressing issues, the last one
is rather a cleanup which I've been asked to implement long
ago, but I'm not sure if anyone picked it up.

Please take a look, thanks!
