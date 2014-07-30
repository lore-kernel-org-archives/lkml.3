Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaG3OMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:12:37 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59424 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaG3OMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140730114313.GG10301@distanz.ch>
References: <1406655864-8694-1-git-send-email-fernando.apesteguia@gmail.com>
	<20140730114313.GG10301@distanz.ch>
Date: Wed, 30 Jul 2014 16:12:34 +0200
Message-ID: <CAGwOe2bmOp-jknvDyLB68sb4KEHkMHMC5=9+HDNHptVHv1Xw7A@mail.gmail.com>
Subject: Re: [PATCH] staging: vt6655: Fix device table definition.
From: =?UTF-8?Q?Fernando_Apestegu=C3=ADa?= 
	<fernando.apesteguia@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 1:43 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
>
> On 2014-07-29 at 19:44:24 +0200, fernando.apesteguia@gmail.com <fernando.apesteguia@gmail.com> wrote:
> > From: Fernando Apesteguia <fernando.apesteguia@gmail.com>
> >
> > Add static to the definition of the pci device table.
> >
> > Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
>
> This change is already part of Greg's tree, see commit
> 9e4c5c2837a4 ("staging: vt6655: statify some variables") in branch
> staging-next. Please make sure you work against that branch (which is
> also a part of linux-next) for any patches you submit.

Ooops. I will. Thanks for the hint!

>
> Cheers
> Tobias
