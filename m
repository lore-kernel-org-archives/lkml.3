Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3DVPRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:17:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3DVPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:17:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 0/4] ARM 64 bit sched_clock take #2
Date: Mon, 22 Apr 2013 17:16:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <51709FD7.8050408@gmail.com> <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304221716.46105.arnd@arndb.de>
X-Provags-ID: V02:K0:XSW7to7psoYKEU5wXlPftHmgVFuXxTIKDLYqJxVmAGM
 llf9vKztnOPH1zQ4JZvZiBghONXPpDGzu+WblXECK4xkuAVtms
 mY76qacKhQENBqRwew/1qxXXEXpxunB+63R6CuryvLIzRKuTYm
 PSeAwSbsSQBdFk4BkH/47XS20/TnRM9AsGWXKOCwlxz6KfhKIm
 mjDlyazJfyd4sBQFaoXBxR8j8Pn/tRkGIxTJPHmRO8gDv0t/kn
 /hft8olK3wdvA9YtCiakjCyjo9KmT68aA/NIqDFThHZBuypPih
 PcySqSFtCahQjSBd8rE1zFBQCuzqYkX7f37ljy8ckFMb5VUsim
 ALo468PTnA20XRWNOrI8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 April 2013, Stephen Boyd wrote:
> This is what I was thinking. I don't see why we can't move this to generic code
> and have arm64 use it too. Those patches will follow once I find an arm64
> compiler.

I don't have enough background to review the patches, but I know that you can
find an arm64 compiler in Ubuntu Raring. If you are running that on one
of your sysstems, just 'apt-get install gcc-aarch64-linux-gnu'.

	Arnd
