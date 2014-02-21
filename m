Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaBUHOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:14:02 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59111 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaBUHN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:13:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhP-e1wt+SnX8WuaxFRq2hZrnO4NLutzaa_ByuJ9J2a9FQ@mail.gmail.com>
References: <CAOMwXhP-e1wt+SnX8WuaxFRq2hZrnO4NLutzaa_ByuJ9J2a9FQ@mail.gmail.com>
Date: Fri, 21 Feb 2014 07:13:59 +0000
X-Google-Sender-Auth: -T3eIwAH6i1EPMH_a5l1uHauVf8
Message-ID: <CAOMwXhMAJwVHPBS=KWGH+HofX275JxyxZkLXMfnKkr04yA7Qig@mail.gmail.com>
Subject: Re: OMAP138 (davinci) ecap driver support
From: Laszlo Papp <lpapp@kde.org>
To: treding@nvidia.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 6:43 AM, Laszlo Papp <lpapp@kde.org> wrote:
> Hi,
>
> we are currently having some implementation of it for an older kernel,
> and I was just wondering if it is worth upstreaming, or the latest
> linux kernel already has support for it, and we can drop our code
> respectively?
>
> I have seen the "./drivers/pwm/pwm-tiecap.c" file, but it seems to be
> designed for AM33XX regardless its generic file name, and Kconfig
> entry.
>
> Cheers, L.

Since both included emails are broken from Thierry and Philip, I am
resending the email with Thierry's updated email as well as including
the linux-omap mailing list.
