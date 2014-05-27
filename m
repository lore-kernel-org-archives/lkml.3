Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaE0UGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:06:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56112 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaE0UGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:06:20 -0400
Message-ID: <5384F034.8030303@infradead.org>
Date: Tue, 27 May 2014 13:06:12 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>, eric.ernst@linux.intel.com
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        mark.gross@intel.com
Subject: Re: [PATCH 1/1] Add kernel parameter for kernel version
References: <1401219641-79301-1-git-send-email-eric.ernst@linux.intel.com> <CA+5PVA5pBb1C7bQE2Od+jamEGr3=hepT-6OVsQFE7GZvU=2_yA@mail.gmail.com>
In-Reply-To: <CA+5PVA5pBb1C7bQE2Od+jamEGr3=hepT-6OVsQFE7GZvU=2_yA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 12:48 PM, Josh Boyer wrote:
> On Tue, May 27, 2014 at 3:40 PM,  <eric.ernst@linux.intel.com> wrote:
>> From: Eric Ernst <eric.ernst@linux.intel.com>
>>
>> Create a kernel cmdline parameter, "version_addendum", which can be
>> used to add text to the kernel version that is reported from
>> /proc/version.
> 
> Why?
> 
> What is the intended purpose of this and why would someone want to use it?

and if the patch were to continue to live, it needs a Documentation addition
to kernel-parameters.txt.

-- 
~Randy
