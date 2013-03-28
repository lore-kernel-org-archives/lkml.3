Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3C1Ibs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:31:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59110 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3C1Ibr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:31:47 -0400
MIME-Version: 1.0
In-Reply-To: <CADpTngWo_c0MHNwYEFwSR_9KQrWKrOVgQSze+rZc4Ze9Rj2hsw@mail.gmail.com>
References: <CADpTngWo_c0MHNwYEFwSR_9KQrWKrOVgQSze+rZc4Ze9Rj2hsw@mail.gmail.com>
Date: Thu, 28 Mar 2013 09:31:46 +0100
Message-ID: <CADpTngW8RTVX28bVJQe5tV_ccc+FNOJezeQbczXFudy+7bMRDQ@mail.gmail.com>
Subject: Re: 3.7.10 kernel crash
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/27 Fabio Coatti <fabio.coatti@gmail.com>:
> Hi all,
> we are experiencing crashes on some servers, right now running 3.7.10;
> I've been able to get only screenshots from dying server that I
> attached below. Probably we can exclude hardware issues, as it
> happened on two different servers.

Further information: those crashes seems to happen only when the
machine is heavily loaded (process, network and so on). We have seen
this pattern several times.



--
Fabio
