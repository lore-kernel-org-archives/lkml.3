Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3EVQdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:33:19 -0400
Received: from kymasys.com ([64.62.140.43]:55042 "HELO kymasys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751543Ab3EVQdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:33:18 -0400
Subject: Re: [PATCH v4 0/6] mips/kvm: Fix ABI for compatibility with 64-bit guests.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Sanjay Lal <sanjayl@kymasys.com>
In-Reply-To: <20130522125453.GN14287@redhat.com>
Date: Wed, 22 May 2013 09:33:17 -0700
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <88128283-D1AD-4D69-B5B5-0579F346087C@kymasys.com>
References: <1369169695-10444-1-git-send-email-ddaney.cavm@gmail.com> <20130522125453.GN14287@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22, 2013, at 5:54 AM, Gleb Natapov wrote:

> On Tue, May 21, 2013 at 01:54:49PM -0700, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>> 
>> The initial patch set implementing MIPS KVM does not handle 64-bit
>> guests or use of the FPU.  This patch set corrects these ABI issues,
>> and does some very minor clean up.
>> 
> Sanjay, is this looks good to you. 
> 
> What userspace MIPS is using for machine emulation? Is there corresponding
> patches to the userspace?

Gleb, I'll post some comments on the patches later in the day.  We use QEMu for the machine emulation. I am in the process of integrating with the new ABI, and will post the QEMU patches shortly.

Regards
Sanjay

