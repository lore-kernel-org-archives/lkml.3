Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3EJPKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:10:11 -0400
Received: from multi.imgtec.com ([194.200.65.239]:15724 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab3EJPKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:10:10 -0400
Message-ID: <518D0D9A.5080502@imgtec.com>
Date: Fri, 10 May 2013 16:09:14 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: James Hogan <james.hogan@imgtec.com>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 0/2] clk: add metag specific gate/mux clocks
References: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com> <1368198127-1295-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1368198127-1295-4-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_10_16_10_08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/13 16:02, James Hogan wrote:
> This adds a metag architecture specific clk-gate and clk-mux which
> extends the generic ones to use global lock2 to protect the register
> fields. It is common with metag to have an RTOS running on a different
> thread or core with access to different bits in the same register (which
> contain clock gate/switch bits for other clocks). Access to such
> registers must be serialised with a global lock such as the one provided
> by the metag architecture port in <asm/global_lock.h>

Hmm, sorry about the duplicated emails, I had *.patch twice in my git
send-email command line :(.

