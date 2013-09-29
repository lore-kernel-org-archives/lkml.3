Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3I2Wqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 18:46:38 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47416 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3I2Wqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 18:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130929224106.GA19331@thunk.org>
References: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
	<1380399187-4962-1-git-send-email-yinghai@kernel.org>
	<20130929224106.GA19331@thunk.org>
Date: Sun, 29 Sep 2013 15:46:33 -0700
X-Google-Sender-Auth: CjWVh09TYKLmfuRcNqvqgMnNT4U
Message-ID: <CA+55aFwjjfV-nV8N8qMnuee_hg=b-3tb9P5hHv1cJR3pp-4wQQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Workaround missing pci_set_master in pci drivers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 3:41 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Sep 28, 2013 at 01:13:07PM -0700, Yinghai Lu wrote:
>> Fixed by add checking in pci_enable_bridge, and call pci_set_master
>> if driver skip that.
>> That will make the code more robot and wade off problem for missing
>> pci_set_master in drivers.
>
> Petty spelling nit; feel free to ignore unless you need to respin the
> patch anyway....
>
> s/robot/robost/

That's an oddly spelled nitpick "correction".

If you really want to fix it, it's "robust" and "ward off problems".
But it's too late now, and the wrong spelling and word choice is in
the git tree and released in the -rc3 I just pushed out.

           Linus
