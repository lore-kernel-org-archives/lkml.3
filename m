Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaHWIuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 04:50:13 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40970 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaHWIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 04:50:10 -0400
Message-Id: <20140823084611.939722362@openvz.org>
User-Agent: quilt/0.60-1
Date: Sat, 23 Aug 2014 12:46:11 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, oleg@redhat.com,
        tj@kernel.org, avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: [patch 0/2 -mm] prctl: PR_SET_MM_MAP -- Drop race window and simplify validate_prctl_map_locked
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here I addressed the comments from previous review pass (thanks a lot for
the comments btw). Please take a look. While these changes are sitting in -mm
tree we've an option to improve struct prctl_mm_map definition (versioning
and such. personally i don't see a need to add some new @version field into
it at moment but more opinions are welcome!).
