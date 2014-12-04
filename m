Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaLDQer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:34:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaLDQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:34:45 -0500
Date: Thu, 4 Dec 2014 08:34:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
        Wanpeng Li <wanpeng.li@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 1/9] x86: export get_xsave_addr
Message-ID: <20141204163443.GA1477@kroah.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
 <1417708634-24333-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417708634-24333-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 04:57:06PM +0100, Paolo Bonzini wrote:
> get_xsave_addr is the API to access XSAVE states, and KVM would
> like to use it.  Export it.

Use it in what way?

> Cc: stable@vger.kernel.org

Why is this a stable patch?

