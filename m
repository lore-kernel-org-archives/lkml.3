Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaGOQyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:54:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27566 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaGOQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:54:03 -0400
To: "Reddy\, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: <jejb@kernel.org>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 2/8][SCSI]mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625103930.GA13003@avagotech.com>
Date: Tue, 15 Jul 2014 12:53:31 -0400
In-Reply-To: <20140625103930.GA13003@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:09:30 +0530")
Message-ID: <yq1vbqyva0k.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> Added code to send an SEP message that turns off the
Sreekanth> Predictive Failure LED when a drive is removed (if Predictive
Sreekanth> Failure LED was turned on).

Sreekanth> Added a new flag 'pfa_led_on' per device that tracks the
Sreekanth> status of Predictive Failure LED. When the drive is removed,
Sreekanth> this flag is checked and sends an SEP message to turn off the
Sreekanth> respective Predictive Failure LED.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
