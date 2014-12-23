Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaLWTuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:50:09 -0500
Received: from www.osadl.org ([62.245.132.105]:34617 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaLWTuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:50:05 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2 0/2] completion documentation proposal
Date: Tue, 23 Dec 2014 20:41:38 +0100
Message-Id: <1419363700-26085-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1/2 brief user documentation - focus on usage/constraints
2/2 detailed documentation - focus on design and implementation

Also not sure if 2/2 the detailed documentation makes sense in this
form - the current kernel documentation has quite varying levels of
detail. The motivation to reference the initiating posts in detail is
that in some cases design details make more sense if one knows what
case motivated the introduction/extension - not sure if this is the
right place though to put all this.

sorry for the resend - managed to send out the unchecked version

patches are against 3.18.0 linux-next

thx!
hofrat
