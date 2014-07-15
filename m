Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbaGOJku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:40:50 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:32978 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaGOJks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140715090456.GD7668@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-27-git-send-email-lftan@altera.com>
	<20140715090456.GD7668@distanz.ch>
Date: Tue, 15 Jul 2014 17:40:47 +0800
X-Google-Sender-Auth: y88v9VYbet5OlEQi0SskiL5cGHw
Message-ID: <CAFiDJ58xUtf5H3igvvca6Xcb227t8t5SYHH4zUvSDrpQh99N8A@mail.gmail.com>
Subject: Re: [PATCH v2 26/29] Add ELF machine define for Nios2
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

On Tue, Jul 15, 2014 at 5:04 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
>
> On 2014-07-15 at 10:45:53 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> > Signed-off-by: Ley Foon Tan <lftan@altera.com>
>
> This should probably be sent/applied before "[PATCH v2 14/29] nios2: ELF
> definitions", since there EM_ALTERA_NIOS2 is already used.
>
Yes, make sense.
Will move this patch before it is used.
