Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaEZRFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:05:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaEZRFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:05:25 -0400
Date: Mon, 26 May 2014 14:01:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, jan.kiszka@siemens.com, kvm@vger.kernel.org,
        gleb@kernel.org, avi.kivity@gmail.com
Subject: Re: [PATCH v2 3/4] KVM: x86: check CS.DPL against RPL during task
 switch
Message-ID: <20140526170118.GC30582@amt.cnet>
References: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
 <1400172691-27030-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400172691-27030-4-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 06:51:30PM +0200, Paolo Bonzini wrote:
> Table 7-1 of the SDM mentions a check that the code segment's
> DPL must match the selector's RPL.  This was not done by KVM,
> fix it.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Exception number is incorrect, however not introduced by this patchset.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

