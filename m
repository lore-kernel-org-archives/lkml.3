Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaK0PQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:16:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaK0PQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:16:10 -0500
Date: Thu, 27 Nov 2014 07:14:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Kalle Valo <kvalo@adurom.com>,
        Sebastian Reichel <sre@ring0.de>,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: wl1251: NVS firmware data
Message-ID: <20141127151448.GA23064@kroah.com>
References: <201411271506.20457@pali>
 <CACVXFVMr8jH1ZzyPNG91VDK8DuVjQsHn9ks62sSNjOfUnNsURQ@mail.gmail.com>
 <201411271543.23527@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411271543.23527@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 03:43:23PM +0100, Pali Rohár wrote:
> Which userspace helper programs for (automatic) firmware loading 
> are used? Can be udev configured to use own program for loading 
> firmware instead that udev integrated which looking for firmware 
> only in /lib/firmware files?

The code to load firmware from userspace has been removed from udev, so
that's not going to work at all, sorry.

greg k-h
