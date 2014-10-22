Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbaJVL1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:27:40 -0400
Received: from tex.lwn.net ([70.33.254.29]:49672 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729AbaJVL1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:27:39 -0400
Date: Wed, 22 Oct 2014 07:27:36 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Masanari Iida <standby24x7@gmail.com>
Cc: jaswinder.singh@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Fix a typo in mailbox.txt
Message-ID: <20141022072736.123b7654@lwn.net>
In-Reply-To: <1413934567-1207-1-git-send-email-standby24x7@gmail.com>
References: <1413934567-1207-1-git-send-email-standby24x7@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 08:36:07 +0900
Masanari Iida <standby24x7@gmail.com> wrote:

> This patch fix a typo in Documentation/mailbox.txt
> "bool async" is defined in struct demo_client.

This seems worthy of application, but it makes me worry: clearly the
example code in this file was not taken from a working file and has not
actually been built.  It seems like this code would be better placed in
samples/ as a working example?

jon
