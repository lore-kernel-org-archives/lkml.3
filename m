Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3K0K0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:26:36 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:56047 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3K0K0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:26:34 -0500
Subject: Re: [PATCH 0/6] Generic WorkQueue Engine (GenWQE) device driver
 (v7)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131122165223.GB30314@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1385127450.14011.3.camel@oc7383187364.ibm.com>
	 <20131122165223.GB30314@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 27 Nov 2013 11:26:28 +0100
Message-ID: <1385547988.23725.31.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112710-1948-0000-0000-00000708A24D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Freitag, den 22.11.2013, 08:52 -0800 schrieb Greg KH:
> On Fri, Nov 22, 2013 at 02:37:30PM +0100, Frank Haverkamp wrote:
> > Hello Greg and others,
> > 
> > is the patchset ok this way, or do you see anything more I should
> > change/improve?
> 
> It is the middle of the 3.13-rc1 merge window, and we are all busy off
> doing other work at the moment.

Thanks for the information. If I saw correctly 3.13-rc1 is out now since
last Friday.

>   So please give us a chance to catch up
> with that, and then, after -rc1 is out, I'll get back to my pending
> patch queue:
>         $ mdfrm -c ~/mail/todo
>         1945 messages in /home/gregkh/mail/todo
> 
> thanks,
> 
> greg k-h

I hope you were able to start reducing the size of your todo queue.
I don't want to annoy you, but is there any progress on our GenWQE
driver?

Thanks

Frank



