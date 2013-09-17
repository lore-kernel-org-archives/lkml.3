Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3IQU2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:28:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab3IQU2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:28:00 -0400
Message-ID: <5238BB4A.8000309@redhat.com>
Date: Tue, 17 Sep 2013 16:27:54 -0400
From: Doug Ledford <dledford@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Hannes Reinecke <hare@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-scsi list <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver
References: <y687fpks4kdsmfuadq4cykip.1379384036544@email.android.com>  <52386730.4060508@suse.de> <1379448641.2213.18.camel@dabdike>
In-Reply-To: <1379448641.2213.18.camel@dabdike>
X-Enigmail-Version: 1.5.2
OpenPGP: id=0E572FDD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/13 16:10, James Bottomley wrote:

> OK, so do we have any real evidence that no-one uses this driver?  Does
> any distro actually compile it, for instance?

Red Hat doesn't use it in any of their products (and it hasn't been the
preferred driver since about the old Red Hat Linux 7.0 days).


-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

