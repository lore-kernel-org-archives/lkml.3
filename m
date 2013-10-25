Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3JYH45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:56:57 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:44840 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3JYH44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:56:56 -0400
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        cody@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        utz.bacher@de.ibm.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        michael@ibmra.de
In-Reply-To: <CAErSpo7e0i=5Yi90rtwfR7MrOpUR3BVkb_neWfdtXJ4=rRyZ8w@mail.gmail.com>
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>
	 <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
	 <CAErSpo7e0i=5Yi90rtwfR7MrOpUR3BVkb_neWfdtXJ4=rRyZ8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 25 Oct 2013 09:56:50 +0200
Message-ID: <1382687810.7782.5.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102507-4966-0000-0000-000007499461
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Am Mittwoch, den 23.10.2013, 12:27 -0600 schrieb Bjorn Helgaas:
> On Thu, Jul 25, 2013 at 2:28 AM, Frank Haverkamp <haver@vnet.ibm.com> wrote:

> > Known Restrictions:
> >
> >  o On my PowerPC testsystem SRIOV did not work.
> 
> Does this restriction still apply?  Is there some PCI core issue here?
>  We did fix an SR-IOV issue that was reported on PowerPC with
> aa914f5ec25, so maybe that's related.  But if there's still a PCI core
> issue here, let me know.
> 
> Bjorn


I should remove this old comment. The Linux version I had to test that
was very old. Also I adjusted the driver to the new recommended
interface which allows to turn on the virtual functions via write to a
sysfs entry allows to use the driver in any case. That allowed me to
remove some ugly ifdefs in the code and the comment was meant to explain
those.

Thanks for pointing this out.

Regards

Frank

