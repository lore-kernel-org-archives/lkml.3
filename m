Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaIVJRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:17:41 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40579 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaIVJRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:17:40 -0400
Message-ID: <541FE92E.9010004@redhat.com>
Date: Mon, 22 Sep 2014 11:17:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: Make init_rmode_tss() return 0 on success.
References: <1410867505-5941-1-git-send-email-pbonzini@redhat.com> <20140919234440.GA2501@potion.redhat.com>
In-Reply-To: <20140919234440.GA2501@potion.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/09/2014 01:44, Radim Krčmář ha scritto:
>> > This patch removes the redundant variable, by making init_rmode_tss()
>> > return 0 on success, -errno on failure.
> Which is going to propagate all the way to userpace through ioctl ...
> is this change of A[PB]I acceptable?
> 
> Otherwise, -EFAULT seems to match unlikely problems better than -ENOMEM,
> so if it is acceptable:  Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

Yes, I think it is a bugfix.

Paolo
