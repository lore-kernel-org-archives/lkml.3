Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3EVKhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:37:47 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:38002 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3EVKhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:37:46 -0400
Date: Wed, 22 May 2013 12:37:30 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Victor Kamensky <kamensky@cisco.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Maneesh Soni <manesoni@cisco.com>, yrl.pp-manager.tt@hitachi.com,
        systemtap@sourceware.org
Subject: Re: [PATCH 2/2] [BUGFIX] kprobes/mips: Fix to check double free of
 insn slot
Message-ID: <20130522103730.GC10769@linux-mips.org>
References: <20130522093409.9084.63554.stgit@mhiramat-M0-7522>
 <20130522093413.9084.33395.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522093413.9084.33395.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.

  Ralf
