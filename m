Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3EGOog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:44:36 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56151 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3EGOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <0000013e7f60169e-47b0bd92-a757-41da-8b30-fa78511fe298-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
	<0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
	<201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
	<0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
	<CAOJsxLGvbJ+FNq8J3j1FHz9gjo7vGgfTyWQT1vvy0D3Ykq8SyA@mail.gmail.com>
	<0000013e7f60169e-47b0bd92-a757-41da-8b30-fa78511fe298-000000@email.amazonses.com>
Date: Tue, 7 May 2013 17:44:32 +0300
X-Google-Sender-Auth: c8uA15JEtgakrrN7aJci8AQmN3c
Message-ID: <CAOJsxLGW6pMeLJ=XRzg1JU6QuT0E+vcFSSay1FbG=-N27aSing@mail.gmail.com>
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Glauber Costa <glommer@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 5:23 PM, Christoph Lameter <cl@linux.com> wrote:
> Well this is because you did not take the patch that changed the way
> KMALLOC_SHIFT_HIGH is treated.

Is that still needed? I only took the ones Tetsuo said were needed to
fix the issue at hand.

                        Pekka
