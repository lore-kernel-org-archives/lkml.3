Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbaISRdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:33:25 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62589 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbaISRdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:33:23 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140919172538.GC34042@vmdeb7>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com> <20140919172538.GC34042@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2 0/9] eeepc cleanup
From: Frans Klaver <fransklaver@gmail.com>
Date: Fri, 19 Sep 2014 19:33:11 +0200
To: Darren Hart <dvhart@infradead.org>
CC: Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <17894680-86be-41f3-8ee4-93704accd374@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 September 2014 19:25:38 CEST, Darren Hart <dvhart@infradead.org> wrote:
>On Wed, Sep 17, 2014 at 11:47:18PM +0200, Frans Klaver wrote:
>> Here's the second installment cleaning up some things in the eeepc
>laptop
>> driver.
>> 
>> This depends on "eeepc-laptop: simplify parse_arg()".
>> 
>> For those interested, I keep a copy based on Darren's testing branch
>on
>> github:
>
>Please note, "testing" is strictly for use with Fengguang's 0day robot.
>It
>*will* rebase and be recreated willy nilly.
>
>If you want to base on something I've queued, I suggest the "for-next"
>branch as
>I expect that to be far more stable. Rabses should be *very* rare
>there.
>
>Feel free to use "testing" if you need to, just be aware it will
>rebase.
>

I'll keep that in mind for the next batch ;) 


>> 
>> 	https://github.com/fransklaver/linux.git tags/eeepc_cleanup_v2
>
>Queued for testing.
>
>Thanks Frans!

Thanks, 
Frans 


