Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbaJ3IcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:32:20 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64097 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaJ3IcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:32:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, tj@kernel.org, marcel@holtmann.org,
        desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com,
        tixxdz@opendz.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: kdbus: add selftests
Date: Thu, 30 Oct 2014 09:31:34 +0100
Message-ID: <27579568.3momLxJBeo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414620056-6675-13-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-13-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:b1d1t0DkN+nzDZ09EJmQLdY+6kqcO/xTO47lJmtz/UR
 DKX+azgbo6TUL8AE8YIdxsukgedGknYGbW9yjWcZbEzX0h9bB/
 AIyDWRg+jzuGYj2kG/O8F0374twHtlCFnlvDkGhwE4WDv1S7FB
 ZvRiPRAoB9QpLhnV9yabyy2pSJZLTmmXtZVQ9Rci3t4zmIthRH
 bH5ksHOK1YRz6JydkzsRjS0lI6o6Nk/Y/ziypkD4+XC0a9GwpL
 yh+im13E3CVK6DzdlkEqLia2L/thclz57yHp7ysuKC/8rxxkqG
 ZjZkxHy2dmTayardZbLyIKaE11dT4FGN+cneYyzy4EY/8vx2aN
 XQKYzfaaOf61A76h+DMg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 15:00:56 Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> 
> This patch adds a quite extensive test suite for kdbus that checks
> the most important code pathes in the driver. The idea is to extend
> the test suite over time.
> 
> Also, this code can serve as an example implementation to show how to
> use the kernel API from userspace.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Ah, new kernel code that comes with selftests, I'm impressed!

	Arnd
