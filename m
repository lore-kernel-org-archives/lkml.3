Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaGVS3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:29:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49128 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaGVS3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:29:16 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v3 0/2] security: introduce kernel_fw_from_file hook
Date: Tue, 22 Jul 2014 11:28:59 -0700
Message-Id: <1406053741-22795-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an LSM hook to the existing firmware loading logic so that
the LSM can reason about the origin and contents of a firmware coming
from userspace.

Thanks,

-Kees

v3:
- correctly return LSM error to userspace (ming.lei)
- finalize memory map before calling LSM hook (tiwai)
v2:
- further clarify header comments (jmorris)

