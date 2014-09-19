Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaISCsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:48:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaISCsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:48:01 -0400
Date: Thu, 18 Sep 2014 19:47:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: jslaby@suse.cz, heikki.krogerus@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Add-Quark-X1000-PCI-desc-clock-and-register-data
Message-ID: <20140919024711.GA30513@kroah.com>
References: <1411088156-19500-1-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411088156-19500-1-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your subject is very odd, please fix it up and use ' ' characters...

Also use a prefix with the area of the kernel you are modifying, for
this one it would be something like "serial: 8250: 

Care to try it again please?

thanks,

greg k-h
