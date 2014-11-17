Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaKQUcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:32:36 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43688 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbaKQUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:32:34 -0500
Date: Mon, 17 Nov 2014 20:32:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Laura Abbott <lauraa@codeaurora.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
Message-ID: <20141117203213.GA4042@n2100.arm.linux.org.uk>
References: <20141114204517.GA24402@www.outflux.net>
 <CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
 <CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
 <CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
 <alpine.DEB.2.11.1411162127310.3909@nanos>
 <CAGXu5jKynZtTu8T333v+ZeUSfhQxgOmc6S3g-GuZzN_e4FvP5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKynZtTu8T333v+ZeUSfhQxgOmc6S3g-GuZzN_e4FvP5Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:27:59PM -0800, Kees Cook wrote:
> I have a series for arm that is waiting to be picked up by rmk:
> https://patchwork.ozlabs.org/patch/400383/

It should've been in linux-next via my tree for the last two weeks
or so.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
