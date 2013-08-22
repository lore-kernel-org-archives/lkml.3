Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3HVBRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:17:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47977 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753140Ab3HVBRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:17:52 -0400
Message-ID: <1377134271.12003.15.camel@joe-AO722>
Subject: Re: [PATCH] scsi: fix the build warning
From: Joe Perches <joe@perches.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date: Wed, 21 Aug 2013 18:17:51 -0700
In-Reply-To: <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 09:05 +0800, Zhi Yong Wu wrote:
> HI,

Hi.

> If you'd like, you should draft one patch for this warning.

Not for me.

I don't get this build warning in the first place and
I think the scsi_debug file is quite old and probably
doesn't need to be changed at all.

I think scsi_debug_guard could be set to a negative
value and then the csum will always be -1.

Dunno if that's a good thing.

Anyway, just a suggestion, do what you want with it.

cheers, Joe

