Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3AKJcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:32:35 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40830
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591Ab3AKJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:32:34 -0500
Date: Fri, 11 Jan 2013 04:32:27 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Josh Stone <jistone@redhat.com>
Cc: oleg@redhat.com, srikar@linux.vnet.ibm.com, mingo@kernel.org,
        peterz@infradead.org, anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add exports for module use
Message-ID: <20130111093227.GA30043@infradead.org>
References: <1357858906-9711-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357858906-9711-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 03:01:46PM -0800, Josh Stone wrote:
> The original pull message for uprobes (commit 654443e2) noted:
> 
>   This tree includes uprobes support in 'perf probe' - but SystemTap
>   (and other tools) can take advantage of user probe points as well.
> 
> In order to actually be usable in module-based tools like SystemTap, the
> interface needs to be exported.  This patch first adds the obvious
> exports for uprobe_register and uprobe_unregister.  Then it also adds
> one for task_user_regset_view, which is necessary to get the correct
> state of userspace registers.

Get systemtap into the mainline kernel tree and we can talk.

