Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaAHVSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480AbaAHVSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:18:34 -0500
Date: Wed, 8 Jan 2014 19:10:10 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Chen Fan <chen.fan.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH] kvm: x86: Fix debug typo error in lapic
Message-ID: <20140108211009.GD20624@amt.cnet>
References: <1388654051-5968-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388654051-5968-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 05:14:11PM +0800, Chen Fan wrote:
> fix the 'vcpi' typos when apic_debug is enabled.
> 
> Signed-off-by: Chen Fan <chen.fan.fnst@cn.fujitsu.com>
> ---
>  arch/x86/kvm/lapic.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

