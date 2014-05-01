Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaEAAIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:08:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45558 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaEAAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:08:28 -0400
Subject: Re: [PATCH 1/3] uprobes/x86: Rename *riprel* helpers to make the
 naming consistent
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140428063456.GA5015@linux.vnet.ibm.com>
References: <20140427165200.GA3956@redhat.com>
	 <20140427165223.GA4013@redhat.com>
	 <20140428063456.GA5015@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 17:07:26 -0700
Message-ID: <1398902846.4878.24.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050100-1542-0000-0000-00000177602C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 12:04 +0530, Srikar Dronamraju wrote:
> * Oleg Nesterov <oleg@redhat.com> [2014-04-27 18:52:23]:
> 
> > handle_riprel_insn(), pre_xol_rip_insn() and handle_riprel_post_xol()
> > look confusing and inconsistent. Rename them into riprel_analyze(),
> > riprel_pre_xol(), and riprel_post_xol() respectively.
> > 
> > No changes in compiled code.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 

Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

