Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaKWIb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 03:31:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60365 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaKWIb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 03:31:26 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <547199B3.1040303@gmail.com>
Date: Sun, 23 Nov 2014 10:31:21 +0200
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <89CF39F2-660B-4999-8D4D-08E4942C58FD@gmail.com>
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com> <547199B3.1040303@gmail.com>
To: Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Nov 23, 2014, at 10:24, Wanpeng Li <kernellwp@gmail.com> wrote:
> 
> Hi Nadav,
> On 11/23/14, 4:16 PM, Nadav Amit wrote:
>> I’ll try to check it tomorrow (I don’t have access to the failing machine at the moment).
> 
> If the machine you mentioned support xsaves and what's machine you are using?

It supports xsaves. I am using an experimental setup.

Nadav