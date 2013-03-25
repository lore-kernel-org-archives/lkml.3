Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab3CYVuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:50:20 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38631 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956Ab3CYVuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130325194245.GA7357@redhat.com>
References: <20130320163131.GE2273@redhat.com>
	<1363807329-24975-1-git-send-email-yinghai@kernel.org>
	<20130325194245.GA7357@redhat.com>
Date: Mon, 25 Mar 2013 14:50:18 -0700
X-Google-Sender-Auth: zedtphvBSLsPpQC6QHQH_WANqAc
Message-ID: <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 12:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> So it is a forgone conclusion that these new kernel changes to
> crashkernel=X in 3.9 are incompatible with older kexec-tools and one
> needs to upgrade kexec-tools.

I thought that you and hpa all agreed that user need to update kexec-tools with
new kernel v3.9. It that still right?

Thanks

Yinghai
