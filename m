Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3A2Lp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:45:57 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40620 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3A2Lpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:45:55 -0500
X-AuditID: 85900ec0-d5479b900000152f-6a-5107b6702886
Message-ID: <5107B670.1000800@hitachi.com>
Date: Tue, 29 Jan 2013 20:45:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, jbaron@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 3/5] kprobes: constify check_kprobe_address_safe and friends
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com> <1357772960-4436-3-git-send-email-sasha.levin@oracle.com> <50FD2B30.20100@hitachi.com> <51020566.6040408@oracle.com>
In-Reply-To: <51020566.6040408@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/25 13:09), Sasha Levin wrote:
> As to arch_check_optimized_kprobe() and check_kprobe_address_safe(), this
> is simply way too confusing. It doesn't make sense that a function named
> check_[...]() would modify any of it's parameters.
> 
> For example, that entire block within KPROBES_CAN_USE_FTRACE should be split
> out and go into update_kprobe_for_ftrace() or something similar.
> 
> If that makes sense, I can send a patch to split out all the parts that
> modify anything in those two functions out of them.

I see, that makes sense :-)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


