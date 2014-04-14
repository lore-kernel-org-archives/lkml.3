Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaDNNsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:48:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:8401 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750993AbaDNNsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:48:46 -0400
Date: Mon, 14 Apr 2014 09:48:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, ltc-kernel@ml.yrl.intra.hitachi.co.jp,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Satoshi Oshima <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH] module: Introduce MODULE_STATE_COMING_FINAL to avoid
 ftrace warning
Message-ID: <20140414094841.492a9576@gandalf.local.home>
In-Reply-To: <534B5F88.6020801@hitachi.com>
References: <1396425266-3128-1-git-send-email-indou.takao@jp.fujitsu.com>
	<534B4CB5.9010401@jp.fujitsu.com>
	<534B5F88.6020801@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 13:09:44 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> >> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> 
> As Steven said, it should have his signed-off too, anyway,
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 

Please resubmit to Rusty with my signed-off-by and Masami's
reviewed-by. 

Thanks,

-- Steve
