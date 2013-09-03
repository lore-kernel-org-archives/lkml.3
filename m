Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393Ab3ICWoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:44:17 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:49409 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760885Ab3ICWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <1378244811.32763.420.camel@haakon3.risingtidesystems.com>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
	<1378161032.32763.341.camel@haakon3.risingtidesystems.com>
	<CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
	<1378169449.32763.347.camel@haakon3.risingtidesystems.com>
	<1378244811.32763.420.camel@haakon3.risingtidesystems.com>
Date: Tue, 3 Sep 2013 15:44:14 -0700
X-Google-Sender-Auth: Q95bO-i6rh1JzKRDpFozVi2Dj4E
Message-ID: <CA+55aFxKiLv1PhZXo-tOazoQ7A6Wxyr=u3WFaFw85QvYiqn0Cw@mail.gmail.com>
Subject: Re: Linux 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 2:46 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> Ok, so another PULL request was sent out last night for the missing
> target fixes below, after putting DKIM + SPF authentication in place for
> linux-iscsi.org:
>
> [GIT PULL -v3] target fixes for v3.12-rc0 (was v3.11)
> http://marc.info/?l=linux-kernel&m=137818849925625&w=2
>
> Watching the recent git activity, I can't tell if you've (not) reached
> this point in the PULL queue yet, or if this email also landed in your
> spam folder..?
>
> Care to give me a hint if your receiving these PULL emails now, or if I
> need to continue looking at why gmail is unhappy..?

That message came through, and has the line

  Received-SPF: pass (google.com: domain of nab@linux-iscsi.org
designates 67.23.28.174 as permitted sender) client-ip=67.23.28.174;

which may or may not have been the thing that made a difference.

I'll get to the pull request itself later..

              Linus
