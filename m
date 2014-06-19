Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbaFSGUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:20:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48017 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaFSGUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:20:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: acme@kernel.org, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] perf bench: sched-messaging: Plug memleak
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
	<1402942467-10671-5-git-send-email-davidlohr@hp.com>
Date: Thu, 19 Jun 2014 15:20:06 +0900
In-Reply-To: <1402942467-10671-5-git-send-email-davidlohr@hp.com> (Davidlohr
	Bueso's message of "Mon, 16 Jun 2014 11:14:22 -0700")
Message-ID: <8738f18lpl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 11:14:22 -0700, Davidlohr Bueso wrote:
> Explicitly free the thread array ('pth_tab').

It seems like sender/receiver contexts were also leaked.

Thanks,
Namhyung
