Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaKKBTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:19:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaKKBTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:19:07 -0500
Date: Mon, 10 Nov 2014 23:18:50 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: add trace event for pvclock updates
Message-ID: <20141111011850.GA12749@amt.cnet>
References: <1415216802-19201-1-git-send-email-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415216802-19201-1-git-send-email-dmatlack@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 11:46:42AM -0800, David Matlack wrote:
> The new trace event records:
>   * the id of vcpu being updated
>   * the pvclock_vcpu_time_info struct being written to guest memory
> 
> This is useful for debugging pvclock bugs, such as the bug fixed by
> "[PATCH] kvm: x86: Fix kvm clock versioning.".
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

So you actually hit that bug in practice? Can you describe the
scenario?


