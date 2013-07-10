Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3GJLjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:39:44 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50718 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3GJLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:39:42 -0400
MIME-Version: 1.0
In-Reply-To: <51DD46AD.2010800@canonical.com>
References: <51DD46AD.2010800@canonical.com>
Date: Wed, 10 Jul 2013 12:39:40 +0100
Message-ID: <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
Subject: Re: [REGRESSION] "UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()" breaks macbook efi boot
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dave Young <dyoung@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2013 12:34, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Hey,
>
> It seems that in the merge window my macbook pro stopped working at some point. I looked for suspicious
> efi related commits, and found that reverting commit 1acba98f810a14b1255e34bc620594f83de37e36 worked,
> letting my macbook pro boot succesfully.

Thanks for the report. I'm going to queue up a revert of this patch,
Dave Young also reported a problem on his thinkpad.

> Is there anything I can do to help diagnose this issue?

Matthew?
