Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3KMX0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:26:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57552 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3KMX0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:26:32 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131113232349.GA13970@amd.pavel.ucw.cz>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org> <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org> <20131111182046.GA14961@gmail.com> <20131113181600.GA6160@amd.pavel.ucw.cz> <5283C7A8.2010902@linux.intel.com> <20131113232349.GA13970@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 13 Nov 2013 15:25:46 -0800
To: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Message-ID: <2482e945-c263-4273-ad09-de83a830ecd6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it literally doesn't exist yet.  As in it isn't in memory at the point this is run.

Pavel Machek <pavel@ucw.cz> wrote:
>On Wed 2013-11-13 10:40:40, H. Peter Anvin wrote:
>> On 11/13/2013 10:16 AM, Pavel Machek wrote:
>> > 
>> > If it is not performance critical, why not use "/dev/random"
>> > infrastructure?
>> > 
>> 
>> Because it doesn't exist yet?
>
>Would it be feasible to initialize /dev/random earlier instead of
>reinventing it?
>									Pavel

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
