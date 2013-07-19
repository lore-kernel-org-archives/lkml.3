Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3GSTUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:20:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GSTUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:20:37 -0400
Date: Fri, 19 Jul 2013 12:20:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniil Bolsun <dan.bolsun@gmail.com>
Cc: Matthias Urlichs <smurf@smurf.noris.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbserial: append Petatel NP10T device to GSM modems list
Message-ID: <20130719192043.GA2222@kroah.com>
References: <20130719072123.GA3486@l33t.onliner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719072123.GA3486@l33t.onliner>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 10:21:23AM +0300, Daniil Bolsun wrote:
> This patch was tested on 3.10.1 kernel.
> 
> Same models of Petatel NP10T modems have different device IDs.
> Unfortunately they have no additional revision information on a board
> which may treat them as different devices. Currently I've seen only
> two NP10T devices with various IDs. Possibly Petatel NP10T list will
> be appended upon devices with new IDs will appear.
> 
> Signed-off-by: Daniil Bolsun <dan.bolsun@gmail.com>

Much better resubmission, thanks.  I'll queue it up in a few days and
you will get an automated email from my system then.

greg k-h
