Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3KEHXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:23:11 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:47312 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3KEHXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:23:09 -0500
Subject: Re: [PATCH 1/9] Generic WorkQueue Engine (GenWQE) device driver
 (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131104221246.GC14141@kroah.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383584889-21594-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131104221246.GC14141@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 05 Nov 2013 08:21:48 +0100
Message-ID: <1383636108.11383.6.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110507-6892-0000-0000-000006CDC6C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 04.11.2013, 14:12 -0800 schrieb Greg KH:
> On Mon, Nov 04, 2013 at 06:08:01PM +0100, Frank Haverkamp wrote:
> > +if GENWQE
> > +
> > +config GENWQE_DEVNAME
> > +        string "Name for sysfs and device nodes"
> > +     default "genwqe"
> > +        help
> > +          Select alternate name for sysfs and device nodes.
> > +
> > +endif
> 
> Why is this still here?  I thought you said you had removed this?
> 

I posted my original v4 version of the code plus the requested changes
on top of it. But I think, I should rather follow Ryans suggestion how
to split the code into multiple patches. See his last mail. So I will
need to spend some time today to get the patch into the form he
suggested.

Regards

Frank

