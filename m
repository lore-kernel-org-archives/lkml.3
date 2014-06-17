Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaFQLSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:18:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54312 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755834AbaFQLSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:18:53 -0400
Date: Tue, 17 Jun 2014 07:18:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Javi Merino" <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH v4 6/7] thermal: add trace events to the power
 allocator governor
Message-ID: <20140617071838.1b0d8673@gandalf.local.home>
In-Reply-To: <1402996493-3578-7-git-send-email-javi.merino@arm.com>
References: <1402996493-3578-1-git-send-email-javi.merino@arm.com>
	<1402996493-3578-7-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014 10:14:52 +0100
"Javi Merino" <javi.merino@arm.com> wrote:

> Add trace events for the power allocator governor and the power actor
> interface of the cpu cooling device.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> 
> ---
> 
> trace-cmd needs the patched attached in
> http://article.gmane.org/gmane.linux.kernel/1704423 for this to work.

The recently released trace-cmd v2.4 contains this.

-- Steve

