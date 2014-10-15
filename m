Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaJOJnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:43:15 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41150 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaJOJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:43:14 -0400
Date: Wed, 15 Oct 2014 11:43:08 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH v2 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141015094308.GA5452@localhost.localdomain>
References: <1413362404-16284-1-git-send-email-huishao@microsoft.com>
 <20141015091808.GB5300@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540C171E@HKXPRD3002MB006.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540C171E@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:21:33AM +0000, Thomas Shao wrote:
> 
> In V2, I address all the Dan's comments.

It is customary to detail the changes in each patch series revision,
in order to make things easier for the reviewers.

Thanks,
Richard
