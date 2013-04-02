Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557Ab3DBJYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:24:07 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36403 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318Ab3DBJYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:24:03 -0400
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Subject: Re: 3.7.10 kernel crash
Date: Tue, 02 Apr 2013 11:16:55 +0200
Message-ID: <1426784.IFBeqasnTm@calvin>
User-Agent: KMail/4.10.1 (Linux/3.8.4; KDE/4.10.1; x86_64; ; )
In-Reply-To: <1364474147.3261.1.camel@thor.lan>
References: <CADpTngWo_c0MHNwYEFwSR_9KQrWKrOVgQSze+rZc4Ze9Rj2hsw@mail.gmail.com> <CADpTngW8RTVX28bVJQe5tV_ccc+FNOJezeQbczXFudy+7bMRDQ@mail.gmail.com> <1364474147.3261.1.camel@thor.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data giovedì 28 marzo 2013 08:35:47, Peter Hurley ha scritto:
> [ +cc Matt Carlson, Michael Chan, netdev because this is a tg3-related oops]
> On Thu, 2013-03-28 at 09:31 +0100, Fabio Coatti wrote:
> > 2013/3/27 Fabio Coatti <fabio.coatti@gmail.com>:
> > > Hi all,
> > > we are experiencing crashes on some servers, right now running 3.7.10;
> > > I've been able to get only screenshots from dying server that I
> > > attached below. Probably we can exclude hardware issues, as it
> > > happened on two different servers.
> > 
> > Further information: those crashes seems to happen only when the
> > machine is heavily loaded (process, network and so on). We have seen
> > this pattern several times.
> 
> I would recommend capturing the entire oops text (it will likely be
> necessary anyway for someone to properly identify and fix the cause).
> 
> If the machine has a 2nd network port, then use netconsole on that
> interface. If not, set up a serial console or try to get 50-line VGA


Ok, I'll try to get better oopes. However, this is going to be tricky, as the 
machine is remotely administered (via HP iLO) and uses all network interfaces 
(BTW, I'm not even sure to be able to get a network driver related crash using 
netconsole approach). So far, no success in using a different resolution for 
boot console.
Anyway, I'll try to find a way to capture all the messages.

Many thanks for the answer!



--
Fabio
