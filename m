Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbaLDSGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:06:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746AbaLDSGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:06:45 -0500
Date: Thu, 4 Dec 2014 19:06:39 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH 7/9] kvm: x86: handle XSAVES vmcs and vmexit
Message-ID: <20141204180638.GD18651@potion.brq.redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
 <1417708634-24333-8-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417708634-24333-8-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 16:57+0100, Paolo Bonzini:
> From: Wanpeng Li <wanpeng.li@linux.intel.com>
> 
> Initialize the XSS exit bitmap.  It is zero so there should be no XSAVES
> or XRSTORS exits.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
