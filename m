Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbaGOJil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:38:41 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:49333 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaGOJih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140715090813.GE7668@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<20140715090813.GE7668@distanz.ch>
Date: Tue, 15 Jul 2014 17:38:36 +0800
X-Google-Sender-Auth: i0L7gXLP-9ue4CAcXrjbWu3q8To
Message-ID: <CAFiDJ5-YNB_uctBYFGkoABHfnwhuncy2FGrQk1j0qPVZBDrC3g@mail.gmail.com>
Subject: Re: [PATCH v2 00/29] nios2 Linux kernel port
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:08 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
>
> On 2014-07-15 at 10:45:27 +0200, Ley Foon Tan <lftan@altera.com> wrote:

>
> Very nice work Ley Foon! It's great to see the Nios II port finally
> making it upstream.
>
> I'll test the series on the NEEK and my custom board some time this
> week.

Hi Tobias

FYI, you need new compiler that support generic ABI syscall. But, this
new compiler is not public available yet.
Will let you know once it is available.

Ley Foon
