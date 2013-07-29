Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3G2Vok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:44:40 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:57928 "EHLO
	smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3G2Voi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:44:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,773,1367971200"; 
   d="scan'208";a="586821442"
Date: Mon, 29 Jul 2013 14:44:19 -0700
From: Matt Wilson <msw@amazon.com>
To: Daniel Kiper <dkiper@net-space.pl>
CC: <gregkh@linuxfoundation.org>, <abyde@acunu.com>, <brandon@ifup.org>,
        <ebiederm@xmission.com>, <grzegorz.milos@gmail.com>,
        <konrad.wilk@oracle.com>, <tim@acunu.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>, <kexec@lists.infradead.org>,
        <daniel.kiper@oracle.com>
Subject: Re: [PATCH] kexec/kdump implementation for Xen PV domU
Message-ID: <20130729214419.GA4239@u109add4315675089e695.ant.amazon.com>
References: <20130729171543.GA2600@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130729171543.GA2600@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 07:15:43PM +0200, Daniel Kiper wrote:
> Hi all,
> 
> Here I am sending as attachments patches enabling kexec/kdump
> support in Xen PV domU. Only x84_64 architecture is supported.
> There is no support for i386 but some code could be easily reused.
> Here is a description of patches:

[...]

>   - kexec-kernel-only_20121203.patch: this patch fixes timer
>     issue on Amazon EC2 machines.

Hi Daniel,

Do you know the cause of this issue? Does it have something to do with
singleshot timer migration when offlining/onlining SMP CPUs?

--msw
