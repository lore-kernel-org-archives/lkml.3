Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3FYSpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:45:43 -0400
Received: from plane.gmane.org ([80.91.229.3]:58805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3FYSpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:45:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Harsh <shreeharshravi@gmail.com>
Subject: Re: vmlinux symtab matching kallsyms fails: =?utf-8?b?ZHNvX19maW5kX3N5bWJvbF9ieV9uYW1l?= ---- end ----
Date: Tue, 25 Jun 2013 18:40:09 +0000 (UTC)
Message-ID: <loom.20130625T203359-102@post.gmane.org>
References: <CAJ_BOiC=nLyaYW9RGFH2xCpEUv6w4tQEHRG9DCc+7bGXDz_stw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 122.167.74.18 (Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you disable symbols_fixup_duplicate and check, I think we need to fix 
it.

- Harsh


