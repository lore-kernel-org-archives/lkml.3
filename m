Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966273Ab3DQMLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:11:54 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55577 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961Ab3DQMLx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:11:1>);
	Wed, 17 Apr 2013 08:11:53 -0400
Message-Id: <516EADD502000078000CE112@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 17 Apr 2013 13:12:37 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, "Victor Miasnikov" <vvm@tut.by>
Cc: <olaf@aepfle.de>, <bp@alien8.de>, <apw@canonical.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <devel@linuxdriverproject.org>,
        <gregkh@linuxfoundation.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        <jasowang@redhat.com>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: KVM  "Hyper-V emulation"   -- this can be related "Linux
 on Hyper-V" ? Or  "KVM emulates Hyper-V" as  "Hyper-V emulates
 Hyper-V" ? Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of
 Hyper-V
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <39D7C3658A5B4979A3F025E1D944E743@local.st.by>
 <20130417101617.GF3881@redhat.com>
In-Reply-To: <20130417101617.GF3881@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.04.13 at 12:16, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> If the hypervisor says it's Hyper-V, that's because it wants
> guests to use Hyper-V. I don't see why is guest second-guessing
> this a good idea.

There are two reasons here: For one, when the hypervisor is not
Hyper-V, but is providing some Hyper-V emulation, that's intended
for Windows guests to use, not e.g. Linux ones, especially when
such guests could use the native hypervisor interface with much
greater benefit.

And second, there reportedly are features of (newer?) Hyper-V
that some emulation may not provide, but that are also not easily
detectable.

Jan

