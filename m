Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab3JDX4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:56:00 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39374 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3JDXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6aE-vxhOHk_mgyWMYrgkG0Juuy8Bs-S2Hjb_7k8S=n8Q@mail.gmail.com>
References: <20131004011806.GE20450@dangermouse.emea.sgi.com>
	<CAErSpo6aE-vxhOHk_mgyWMYrgkG0Juuy8Bs-S2Hjb_7k8S=n8Q@mail.gmail.com>
Date: Fri, 4 Oct 2013 16:55:56 -0700
X-Google-Sender-Auth: bB_9QCasGxFa9zT-MTG8ypE3FnI
Message-ID: <CAE9FiQV_aDmUqGO7HyybwH5fMYqjVpimKF7YA=Jp4EDSFzbQDA@mail.gmail.com>
Subject: Re: Commit 07f9b61 breaks systems that don't implement a _CBA method
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ethan Zhao <ethan.zhao@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 3:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Oct 3, 2013 at 7:18 PM, Hedi Berriche <hedi@sgi.com> wrote:

> It's regrettable that the code is so subtle.  The obvious thing to do
> would be to check for _CBA, and if it doesn't exist, look for an MCFG
> entry.  But for various historical reasons, the code is a mess, and we
> haven't figured out how to safely simplify it.
>
> Ethan, Yinghai, any objections to reverting 07f9b61?

yes, that is right solution.
