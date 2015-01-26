Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbbAZVdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:33:13 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:60233 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbbAZVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:33:11 -0500
Date: Mon, 26 Jan 2015 21:32:40 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Stezenbach <js@sig21.net>, arnd@arndb.de, ebiederm@xmission.com,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Message-ID: <20150126213240.63d07005@lxorguk.ukuu.org.uk>
In-Reply-To: <20150120011359.GE865@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
	<20150119180642.GA27957@sig21.net>
	<20150119183806.GA8479@kroah.com>
	<20150119201906.GA337@sig21.net>
	<20150119203155.GA15441@kroah.com>
	<20150119233812.GA1874@sig21.net>
	<20150120011359.GE865@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015 09:13:59 +0800
> That's because people have not done anything really needing performance
> on the desktop over D-Bus in the past due to how slow the current
> implementation is. 

The desktop is a performance critical environment, even though certain
desktop developers think 2GB is a bit small to run an application and
5000 dbus transactions to start something is "ok"

Alan
