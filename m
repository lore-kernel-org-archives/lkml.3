Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3AVCh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:37:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3AVCh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:37:57 -0500
Date: Mon, 21 Jan 2013 22:59:33 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 1/3] KVM: x86: clean up reexecute_instruction
Message-ID: <20130122005933.GA28298@amt.cnet>
References: <50F2D64C.4030804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F2D64C.4030804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 11:44:12PM +0800, Xiao Guangrong wrote:
> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
> retry_instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Applied series, thanks.

