Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3IWOmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:42:24 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33977 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3IWOmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:42:22 -0400
MIME-Version: 1.0
In-Reply-To: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
References: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 23 Sep 2013 07:41:41 -0700
Message-ID: <CALkWK0mPwtD5MiB1SpUCD6fZq=zcLo5PnTZVAe9YgOOd3azmJA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Trivial sparse acquire/release annotations
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> Ramkumar Ramachandra (3):
>   nfs: add lock annotations to squelch sparse warnings
>   apic: add lock annotations to squelch sparse warnings
>   irq: add lock annotation to squelch a sparse warning

Ping. Can someone pick these up?
