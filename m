Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3AQCyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:25 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35790 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab3AQCyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:25 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/86] remove CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:52:52 -0800
Message-Id: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's what's left of the "remove experimental" tree. (We're down from
193 patches! Thanks everyone!)

This set of patches have either gone without Acks in the prior two
sendings, or introduce a new removal of EXPERIMENTAL where it was
recently added.

https://lkml.org/lkml/2012/10/23/580

-Kees

