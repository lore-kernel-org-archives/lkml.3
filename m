Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbaLDXkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:40:53 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46721 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbaLDXkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:40:51 -0500
MIME-Version: 1.0
In-Reply-To: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
Date: Thu, 4 Dec 2014 15:40:50 -0800
X-Google-Sender-Auth: QmemYKl1PTloE6Uww1uxNF7JwhE
Message-ID: <CA+55aFxJJzc0Q_g336JDuPapG+Q8FKw4v+-bV3CkG=6UzVwfhw@mail.gmail.com>
Subject: Re: [PATCHv4 0/9] ACCESS_ONCE and non-scalar accesses
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 2:30 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> Linus, ok for the next merge window?

Yup, sounds like a plan to me.

              Linus
