Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbbA1ULq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:11:46 -0500
Received: from tex.lwn.net ([70.33.254.29]:35193 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbbA1UKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:10:51 -0500
Date: Wed, 28 Jan 2015 12:13:17 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v0] lockstat: Add documentation on contention and
 contenting points
Message-ID: <20150128121317.6fa56fdb@lwn.net>
In-Reply-To: <1421161170-13045-1-git-send-email-daniel.wagner@bmw-carit.de>
References: <1421161170-13045-1-git-send-email-daniel.wagner@bmw-carit.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 15:59:30 +0100
Daniel Wagner <daniel.wagner@bmw-carit.de> wrote:

> I spent some time to figure out what I saw in /proc/lock_stat. Maybe
> someone else has the same question.

I've applied this to the docs tree, thanks.

jon
