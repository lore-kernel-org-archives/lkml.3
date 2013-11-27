Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3K0TZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:25:28 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39003 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab3K0TZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:25:25 -0500
Date: Wed, 27 Nov 2013 19:24:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: bhelgaas@google.com, cl91tp@gmail.com, tianyu.lan@intel.com,
        khlebnikov@openvz.org, gnomes@lxorguk.ukuu.org.uk,
        indou.takao@jp.fujitsu.com, jility09@gmail.com, f.otti@gmx.at,
        ebiederm@xmission.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
Message-ID: <20131127192420.GC11829@srcf.ucam.org>
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:18:28PM -0700, Khalid Aziz wrote:

> +/* flag to track if kexec reboot is in progress */
> +extern unsigned long kexec_in_progress;

Adding this to pci.h seems a little odd. We may want to use it somewhere 
else at some point. Add it to kexec.h instead?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
