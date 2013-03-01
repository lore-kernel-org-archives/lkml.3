Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3CAQO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:14:56 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:33247 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3CAQOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:14:55 -0500
Message-ID: <5130D3EE.4090205@acm.org>
Date: Fri, 01 Mar 2013 17:14:38 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.8+ merge window
References: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/13 10:19, James Bottomley wrote:
> This is an assorted set of stragglers into the merge window with driver
> updates for qla2xxx, megaraid_sas, storvsc and ufs.  It also includes
> pulls of the uapi tree (all the remaining SCSI pieces) and the fcoe tree
> (updates to fcoe and libfc)

Hello James,

I'm curious to know your opinion about the patch called "Fix race 
between starved list processing and device removal" 
(http://article.gmane.org/gmane.linux.scsi/80090/match=scsi_run_queue) ? 
It was posted for the first time several months ago and has been ack-ed 
and tested by other people. So far I haven't seen any comments from you 
on that patch.

Bart.

