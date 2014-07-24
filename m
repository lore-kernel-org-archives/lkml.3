Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbaGXQvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:51:49 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:41505 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574AbaGXQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:50:55 -0400
Message-Id: <20140724164657.452106845@openvz.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Jul 2014 20:46:57 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: gorcunov@openvz.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: [rfc 0/4] prctl: set-mm -- Rework interface, v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi, here is a second version. I've tried to address all comments
(for which I'm really grateful). I believe the main question which
remains opened is exe-fd setup. Hopefully the current limitation
(root only) would be enough.

Also, Julien, there is no additional need for ordering test of
@start_stack member since we use find_vma helper.

Please take a look, once you have a spare minutes, thanks!

	Cyrill
