Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3CKTeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:34:03 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54990 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3CKTeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:34:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130311191031.GD12107@redhat.com>
References: <513D52BA.3070206@redhat.com>
	<1362977817-23297-1-git-send-email-yinghai@kernel.org>
	<20130311144853.GB8482@redhat.com>
	<20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com>
	<513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
	<20130311191031.GD12107@redhat.com>
Date: Mon, 11 Mar 2013 12:34:00 -0700
X-Google-Sender-Auth: V4-M9J-ZiOOjj2NkJJ06LvyFqgk
Message-ID: <CAE9FiQUxmipKJfUsZdN+J6wGR66VKfLQ8+z41yd3TCJxXTyDRA@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Not breaking existing cases makes sense to me.

that is -v2 version:
try 896M, then try 4G, than MAXMEM.

> May be we should use
> a new parameter crashkernel_high to force memory reservation above
> 4G and crashkernel=X continues to reserve memory at lower addresses
> and remains backward compatible.

No need to use crashkernel_high, we can just cashkernel=X@Y instead.

Thanks

Yinghai
