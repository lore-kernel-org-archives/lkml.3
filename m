Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaEAAI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:08:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34721 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaEAAIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:08:55 -0400
Subject: Re: [PATCH 2/3] uprobes/x86: Kill the "autask" arg of
 riprel_pre_xol()
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
In-Reply-To: <20140428063541.GB5015@linux.vnet.ibm.com>
References: <20140427165200.GA3956@redhat.com>
	 <20140427165227.GA4016@redhat.com>
	 <20140428063541.GB5015@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 17:07:51 -0700
Message-ID: <1398902871.4878.25.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050100-0928-0000-0000-0000019A7AB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 12:05 +0530, Srikar Dronamraju wrote:
> * Oleg Nesterov <oleg@redhat.com> [2014-04-27 18:52:27]:
> 
> > default_pre_xol_op() passes &current->utask->autask to riprel_pre_xol()
> > and this is just ugly because it still needs to load current->utask to
> > read ->vaddr.
> > 
> > Remove this argument, change riprel_pre_xol() to use current->utask.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

