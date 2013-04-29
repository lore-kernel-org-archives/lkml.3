Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3D2Mu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:50:29 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40584 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab3D2Mu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:50:28 -0400
MIME-Version: 1.0
In-Reply-To: <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
 <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de> <87obcyc9sh.fsf@rustcorp.com.au>
 <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 29 Apr 2013 13:50:07 +0100
Message-ID: <CAFEAcA-qfbMWD4fxLSN5uiBzO4fjqpwnx5pZd2QY=6Q=+dMNPw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
To: Alexander Graf <agraf@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2013 13:22, Alexander Graf <agraf@suse.de> wrote:
> Oh, and it should default to off.

That would be a pretty unhelpful default. We should default
things so that console output from the kernel is available
as early as reasonably possible by default IMHO -- this
reduces the number of "nothing happens" user complaints
where you then have to explain how to enable early printk
so you can get some actual information about what happened.

-- PMM
