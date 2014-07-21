Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbaGUTGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 15:06:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40038 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933419AbaGUTGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 15:06:52 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2 0/2] security: introduce kernel_fw_from_file hook
Date: Mon, 21 Jul 2014 12:06:39 -0700
Message-Id: <1405969601-4234-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a reduced version of the original patch. This adds only the LSM
hook to the existing firmware loading logic so that the LSM can reason
about the origin and contents of a firmware coming from userspace.

Thanks!

-Kees

v2:
- further clarify header comments (jmorris)

