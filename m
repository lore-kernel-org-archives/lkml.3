Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3FYRKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:10:20 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:39112 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3FYRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:10:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKSMtaLsTGYqpxnEM-dW+99SYhE1+SzLsD3gngxhxYN7w@mail.gmail.com>
References: <20130625090253.26584.65072.stgit@aruna-ThinkPad-T420>
	<CAGXu5jKSMtaLsTGYqpxnEM-dW+99SYhE1+SzLsD3gngxhxYN7w@mail.gmail.com>
Date: Tue, 25 Jun 2013 10:10:18 -0700
Message-ID: <CA+8MBbJ5Fa_q0_iS34g+5A5ghm087feODsCgMUJZJAGWTo_ZPg@mail.gmail.com>
Subject: Re: [PATCH v2] pstore: Fail to unlink if a driver has not defined pstore_erase
From: Tony Luck <tony.luck@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:41 AM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Jun 25, 2013 at 2:03 AM, Aruna Balakrishnaiah
> <aruna@linux.vnet.ibm.com> wrote:
>> pstore_erase is used to erase the record from the persistent store.
>> So if a driver has not defined pstore_erase callback return

How do people manage devices like this?  With no erase function
they just keep getting more and more pstore entries. Eventually
they fill up.


>> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
>
> Acked-by: Kees Cook <keescook@chromium.org>

Applied - thanks.

-Tony
