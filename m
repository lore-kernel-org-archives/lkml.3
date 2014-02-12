Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaBLVUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:20:42 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42939 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaBLVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:20:41 -0500
Message-ID: <52FBE5A5.3040602@converseincode.com>
Date: Wed, 12 Feb 2014 13:20:37 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, dl9pf@gmx.de
CC: David Woodhouse <David.Woodhouse@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, acpi: LLVMLinux: Remove nested functions from Thinkpad
 ACPI
References: <1392238726-18787-1-git-send-email-dl9pf@gmx.de> <20140212211159.GA29409@infradead.org>
In-Reply-To: <20140212211159.GA29409@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/14 13:11, Christoph Hellwig wrote:
> On Wed, Feb 12, 2014 at 09:58:46PM +0100, dl9pf@gmx.de wrote:
>> being able to compile the Linux kernel with Clang. The use of nested functions
>> blocks this effort.
> Is there any good way to make gcc warn about the use of nested functions?
Interesting idea.

'-Wtrampolines'
      Warn about trampolines generated for pointers to nested functions.

      A trampoline is a small piece of data or code that is created at
      run time on the stack when the address of a nested function is
      taken, and is used to call the nested function indirectly.  For
      some targets, it is made up of data only and thus requires no
      special treatment.  But, for most targets, it is made up of code
      and thus requires the stack to be made executable in order for the
      program to work properly.


That might work.

Behan

-- 
Behan Webster
behanw@converseincode.com

