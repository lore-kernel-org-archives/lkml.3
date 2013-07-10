Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3GJNaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:30:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:34222 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab3GJNaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:30:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] socket.7: add description for SO_BUSY_POLL
Date: Wed, 10 Jul 2013 12:55:19 +0000
Organization: D03
Message-ID: <u0lr4f6h8w8.fsf@orc05.imf.au.dk>
References: <20130710121745.13118.86907.stgit@ladj378.jer.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-man@vger.kernel.org, netdev@vger.kernel.org
X-Gmane-NNTP-Posting-Host: orc05.imf.au.dk
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (gnu/linux)
Cancel-Lock: sha1:vLfgczfn14rM3xP3Hi4P1NXMAII=
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliezer Tamir <eliezer.tamir@linux.intel.com> writes:

> +While busy polling my improve latency of some application, care must be
> +taken when using it since this will increase both CPU utilization power usage.

s/my/may/; missing 'and' before 'power usage'. [And should
'application' be plural?]

Rasmus

