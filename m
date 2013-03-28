Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3C1Mfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:35:54 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:49337 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab3C1Mfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:35:52 -0400
Message-ID: <1364474147.3261.1.camel@thor.lan>
Subject: Re: 3.7.10 kernel crash
From: Peter Hurley <peter@hurleysoftware.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Date: Thu, 28 Mar 2013 08:35:47 -0400
In-Reply-To: <CADpTngW8RTVX28bVJQe5tV_ccc+FNOJezeQbczXFudy+7bMRDQ@mail.gmail.com>
References: <CADpTngWo_c0MHNwYEFwSR_9KQrWKrOVgQSze+rZc4Ze9Rj2hsw@mail.gmail.com>
	 <CADpTngW8RTVX28bVJQe5tV_ccc+FNOJezeQbczXFudy+7bMRDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ +cc Matt Carlson, Michael Chan, netdev because this is a tg3-related oops]

On Thu, 2013-03-28 at 09:31 +0100, Fabio Coatti wrote:
> 2013/3/27 Fabio Coatti <fabio.coatti@gmail.com>:
> > Hi all,
> > we are experiencing crashes on some servers, right now running 3.7.10;
> > I've been able to get only screenshots from dying server that I
> > attached below. Probably we can exclude hardware issues, as it
> > happened on two different servers.
> 
> Further information: those crashes seems to happen only when the
> machine is heavily loaded (process, network and so on). We have seen
> this pattern several times.

I would recommend capturing the entire oops text (it will likely be
necessary anyway for someone to properly identify and fix the cause).

If the machine has a 2nd network port, then use netconsole on that
interface. If not, set up a serial console or try to get 50-line VGA
working.

Regards,
Peter Hurley


