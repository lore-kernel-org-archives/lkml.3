Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3C2PQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:16:39 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51816 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab3C2PQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 29 Mar 2013 09:16:16 -0600
Message-ID: <CAErSpo75xgZHyUtj2vGd-iuJvL8t8mK+EA8npRP2QCMjUbZEOw@mail.gmail.com>
Subject: Re: [PATCH 0/2] eisa: fix eisa with PCI
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Wed, Mar 27, 2013 at 10:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Looks like pci eisa bridge support is broken for a while.
>
> one is root io resource reference, and other one is pnp related.
>
> Please check if we can put them in v3.9.
>         eisa, PCI: Fix bus res reference
>         eisa, PCI: init eisa early before pnp step in

Both of these patches are to drivers/eisa/pci_eisa.c.  I don't see an
EISA-specific maintainer, and I caused at least one of these problems,
so I'll push these through my PCI tree unless somebody objects.

Bjorn
