Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab3DBPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:50:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55083 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab3DBPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:50:32 -0400
Message-ID: <515AFE32.1020600@zytor.com>
Date: Tue, 02 Apr 2013 08:50:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: George Dunlap <george.dunlap@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH v2] perf: Check all MSRs before passing hw check
References: <1363606045-6805-1-git-send-email-george.dunlap@eu.citrix.com> <515AC010.6060001@eu.citrix.com>
In-Reply-To: <515AC010.6060001@eu.citrix.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:25 AM, George Dunlap wrote:
> Any opinions on this?  It's been 2 weeks now.
> 
>  -George

Please just set bios_fail = 1 and save the values in the running code
and do *one* printk() at the end.  Otherwise it seems okay.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

