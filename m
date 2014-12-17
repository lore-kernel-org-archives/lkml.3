Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaLQStj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:49:39 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:65125 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaLQStg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:49:36 -0500
MIME-Version: 1.0
In-Reply-To: <5491ACE6.4070108@ti.com>
References: <54907884.2040502@ti.com> <5491ACE6.4070108@ti.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 17 Dec 2014 11:49:15 -0700
Message-ID: <CAErSpo4hwMPOYBDZTu_fgKaUDYZ4h+jVpz5EigpErOgo6xO8mQ@mail.gmail.com>
Subject: Re: How to fix CHECK warning: testing a 'safe expression' ?
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Christopher Li <sparse@chrisli.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Christopher, linux-kernel (this doesn't sound like a PCI-specific
question)]

On Wed, Dec 17, 2014 at 9:18 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> I am trying to address CHECK warnings in my driver and wondering how to
> resolve 'warning: testing a 'safe expression' which appears when using
> IS_ERR_OR_NULL(foo)
>
> where foo is defined as
>
> struct foo_type *foo;
>
> The foo get assigned only NULL or ERR_PTR(error code). So I believe the
> usage is correct. But then how do I make the CHECK happy of its usage?
>
> I have tried a grep to check on the current usage of IS_ERR_OR_NULL() and
> found 276 of them causes this warning in the v3.18 version of the kernel
> that I am using
>
> $ grep -r "warning: testing a 'safe expression" * | wc -l
> 276
>
> Can someone help me undestand what this means and how to fix the same?
>
> I run folling for CHECK
>
> make C=2 CF="-D__CHECK_ENDIAN__" CHECK=sparse

If you can share your actual code or point to it in the tree, you
might get more specific help.

Bjorn
