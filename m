Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3FYQlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:41:07 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53210 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3FYQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:41:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130625090253.26584.65072.stgit@aruna-ThinkPad-T420>
References: <20130625090253.26584.65072.stgit@aruna-ThinkPad-T420>
Date: Tue, 25 Jun 2013 09:41:03 -0700
X-Google-Sender-Auth: 7GU4sBjfNNxzSwKVWVvWFGHPd8M
Message-ID: <CAGXu5jKSMtaLsTGYqpxnEM-dW+99SYhE1+SzLsD3gngxhxYN7w@mail.gmail.com>
Subject: Re: [PATCH v2] pstore: Fail to unlink if a driver has not defined pstore_erase
From: Kees Cook <keescook@chromium.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 2:03 AM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> pstore_erase is used to erase the record from the persistent store.
> So if a driver has not defined pstore_erase callback return
> -EPERM instead of unlinking a file as deleting the file without
> erasing its record in persistent store will give a wrong impression
> to customers.
>
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

--
Kees Cook
Chrome OS Security
