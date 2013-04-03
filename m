Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211Ab3DCLtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:49:09 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:53072 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760690Ab3DCLtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:49:07 -0400
Message-ID: <1364989741.3825.27.camel@thor.lan>
Subject: Re: 3.7.10 kernel crash
From: Peter Hurley <peter@hurleysoftware.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Date: Wed, 03 Apr 2013 07:49:01 -0400
In-Reply-To: <1426784.IFBeqasnTm@calvin>
References: <CADpTngWo_c0MHNwYEFwSR_9KQrWKrOVgQSze+rZc4Ze9Rj2hsw@mail.gmail.com>
	 <CADpTngW8RTVX28bVJQe5tV_ccc+FNOJezeQbczXFudy+7bMRDQ@mail.gmail.com>
	 <1364474147.3261.1.camel@thor.lan> <1426784.IFBeqasnTm@calvin>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 11:16 +0200, Fabio Coatti wrote:
> Ok, I'll try to get better oopes. However, this is going to be tricky, as the 
> machine is remotely administered (via HP iLO) and uses all network interfaces 
> (BTW, I'm not even sure to be able to get a network driver related crash using 
> netconsole approach)

I use a separate network adapter specifically dedicated for netconsole
(but then I'm trying to crash the machine :)

> So far, no success in using a different resolution for 
> boot console.

What distribution is this and what bootloader are you using?



