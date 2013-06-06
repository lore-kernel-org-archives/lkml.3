Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3FFPBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab3FFPBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:01:39 -0400
Date: Thu, 6 Jun 2013 11:01:12 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Increase the number of USB to serial devices we can
 support at once
Message-ID: <20130606150112.GA22984@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Tobias Winter <tobias@linuxdingsda.de>,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130605175426.GA13461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605175426.GA13461@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:54:26AM -0700, Greg KH wrote:
 > Here are 3 patches that I've tested out on my system with only a small
 > number of devices, but it seems to work, so why not let others try it
 > out...
 > 
 > These patches make the USB to serial core have the ability to support up
 > to 3000 devices at once now.  

I'm curious how this works. What systems have 3000 usb ports ?
Or are there some kind of multiplexer devices out there ?
(If so, I'd like a link, I could use one of those).

	Dave

