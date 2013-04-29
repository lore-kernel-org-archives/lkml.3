Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3D2MyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:54:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab3D2Mx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:53:59 -0400
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAFEAcA-qfbMWD4fxLSN5uiBzO4fjqpwnx5pZd2QY=6Q=+dMNPw@mail.gmail.com>
Date: Mon, 29 Apr 2013 14:53:58 +0200
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Transfer-Encoding: 8BIT
Message-Id: <9DCAE29E-A113-4E74-A663-1AB224AD97E0@suse.de>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de> <87obcyc9sh.fsf@rustcorp.com.au> <336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de> <CAFEAcA-qfbMWD4fxLSN5uiBzO4fjqpwnx5pZd2QY=6Q=+dMNPw@mail.gmail.com>
To: Peter Maydell <peter.maydell@linaro.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 29.04.2013, at 14:50, Peter Maydell wrote:

> On 29 April 2013 13:22, Alexander Graf <agraf@suse.de> wrote:
>> Oh, and it should default to off.
> 
> That would be a pretty unhelpful default. We should default
> things so that console output from the kernel is available
> as early as reasonably possible by default IMHO -- this
> reduces the number of "nothing happens" user complaints
> where you then have to explain how to enable early printk
> so you can get some actual information about what happened.

Users complaining that they only see half of their kernel log are even worse IMHO :)


Alex

