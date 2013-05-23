Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab3EWK17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:27:59 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37769 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab3EWK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <s5hwqqqvw59.wl%tiwai@suse.de>
References: <20130521230332.GC12713@redhat.com>
	<519D1668.6000601@zytor.com>
	<20130522200012.GA15456@redhat.com>
	<ebdf0a48-4f93-48da-a0a2-b601268c8fb2@email.android.com>
	<20130523033911.GA9411@redhat.com>
	<CACVXFVP3stgc2JKc31_yjPuokTbqcSrW_FWDvHrHK+NA-xu-yg@mail.gmail.com>
	<s5h7giq86hr.wl%tiwai@suse.de>
	<s5hwqqqvw59.wl%tiwai@suse.de>
Date: Thu, 23 May 2013 18:27:57 +0800
Message-ID: <CACVXFVMsTjSqvyVkZEPfWgHDUJ_mqwqWy=vydCsTvv7TS-EKiQ@mail.gmail.com>
Subject: Re: microcode loading got really slow.
From: Ming Lei <tom.leiming@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        fenghua.yu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 6:16 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
> Thinking on this again, if the user-space continues to be broken in
> that point, we should provide request_firmware() variant without udev,
> e.g. request_firmware_direct(), and use it in known places like this?

As anish said, it has been already there, wrt. this problem, I think we
need to know why the direct loading is failed.


Thanks,
-- 
Ming Lei
