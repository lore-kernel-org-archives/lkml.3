Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3H0FT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 01:19:57 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:36999 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3H0FT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 01:19:56 -0400
Message-ID: <521C36F4.8030607@linux.vnet.ibm.com>
Date: Tue, 27 Aug 2013 10:49:48 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: Re: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420> <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420> <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com> <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082705-4790-0000-0000-000009FE6B2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013 04:47 AM, Luck, Tony wrote:
> <1>[  383.209057] RIP  [<ffffffff813d3946>] sysrq_handle_crash+0x16/0x20
> <4>[  383.209057]  RSP <ffff88006f551e80>
> <4>[  383.209057] CR2: 0000000000000000
> <4>[  383.209057] ---[ end trace 04a1cddad37b4b33 ]---
> <3>[  383.209057] pstore: compression failed for Part 2 returned -5
> <3>[  383.209057] pstore: Capture uncompressed oops/panic report of Part 2
> <3>[  383.209057] pstore: compression failed for Part 5 returned -5
>
> Interesting.  With ERST backend I didn't see these messages.  Traces in
> pstore recovered files go as far as the line before the "---[ end trace 04a1cddad37b4b33 ]---"
>
> Why the difference depending on which back end is in use?
>
> But I agree that we shouldn't have these messages.  They use up space
> in the persistent store that could be better used saving some more lines
> from earlier in the console log.

Yeah. We can remove these messages as it will add to the space consumed. But it 
would
be good to know why the compression failed with efivars case.

Seiji,

Could you let us know the efivars buffer size with which the pstore is 
registered when
the failure occurred.

Regards,
Aruna


>
> -Tony
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

