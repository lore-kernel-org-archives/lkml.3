Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386Ab3ICWvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:51:08 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:40912 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760732Ab3ICWvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:51:06 -0400
Message-ID: <1378249100.32763.427.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.11
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Sep 2013 15:58:20 -0700
In-Reply-To: <CA+55aFxKiLv1PhZXo-tOazoQ7A6Wxyr=u3WFaFw85QvYiqn0Cw@mail.gmail.com>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
	 <1378161032.32763.341.camel@haakon3.risingtidesystems.com>
	 <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
	 <1378169449.32763.347.camel@haakon3.risingtidesystems.com>
	 <1378244811.32763.420.camel@haakon3.risingtidesystems.com>
	 <CA+55aFxKiLv1PhZXo-tOazoQ7A6Wxyr=u3WFaFw85QvYiqn0Cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 15:44 -0700, Linus Torvalds wrote:
> On Tue, Sep 3, 2013 at 2:46 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > Ok, so another PULL request was sent out last night for the missing
> > target fixes below, after putting DKIM + SPF authentication in place for
> > linux-iscsi.org:
> >
> > [GIT PULL -v3] target fixes for v3.12-rc0 (was v3.11)
> > http://marc.info/?l=linux-kernel&m=137818849925625&w=2
> >
> > Watching the recent git activity, I can't tell if you've (not) reached
> > this point in the PULL queue yet, or if this email also landed in your
> > spam folder..?
> >
> > Care to give me a hint if your receiving these PULL emails now, or if I
> > need to continue looking at why gmail is unhappy..?
> 
> That message came through, and has the line
> 
>   Received-SPF: pass (google.com: domain of nab@linux-iscsi.org
> designates 67.23.28.174 as permitted sender) client-ip=67.23.28.174;
> 
> which may or may not have been the thing that made a difference.
> 

Excellent, thanks for confirming it made it through this time.

> I'll get to the pull request itself later..
> 

<nod>, now back to the real v3.12-rc1 items.

Thanks again,

--nab

