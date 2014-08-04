Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaHDR0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:26:15 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:47436 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaHDR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:26:13 -0400
Message-Id: <20140804172255.109539743@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 21:22:55 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: gorcunov@openvz.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: [patch 0/4] prctl: set-mm -- Rework interface, v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! Here is (I hope) a final version of the series (i've had a typo
in check_data_rlimit helper, thanks serge.hallyn@ for spotting it).

Please take a look once time permit (and drop previous two verisions
from mbox). Thanks!

	Cyrill
