Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3KVQwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:52:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3KVQwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:52:24 -0500
Date: Fri, 22 Nov 2013 08:52:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH 0/6] Generic WorkQueue Engine (GenWQE) device driver (v7)
Message-ID: <20131122165223.GB30314@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
 <1385127450.14011.3.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385127450.14011.3.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:37:30PM +0100, Frank Haverkamp wrote:
> Hello Greg and others,
> 
> is the patchset ok this way, or do you see anything more I should
> change/improve?

It is the middle of the 3.13-rc1 merge window, and we are all busy off
doing other work at the moment.  So please give us a chance to catch up
with that, and then, after -rc1 is out, I'll get back to my pending
patch queue:
	$ mdfrm -c ~/mail/todo
	1945 messages in /home/gregkh/mail/todo

thanks,

greg k-h
