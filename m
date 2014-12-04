Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaLDCzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:55:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51044 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaLDCzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:55:38 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/22] [SCSI] mpt2sas, mpt3sas: Added support to log message when Temperature Threshold exceeds for any Sensor
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-3-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Wed, 03 Dec 2014 21:55:05 -0500
In-Reply-To: <1416467155-16869-3-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:35 +0530")
Message-ID: <yq1vblsi0om.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> This patch will log a message when driver receives
Sreekanth> "Temperature Threshold exceeded" event from any temperature
Sreekanth> sensor.  The message will look similar to like mpt3sas0:
Sreekanth> Temperature Threshold flags a b c d exceeded for Sensor: x
Sreekanth> !!!  mpt3sas0: Current Temp In Celsius: y

Sreekanth> where a b c d are threshold flags 0 1 2 3

Changes look fine. However, I'm a bit concerned about the unbounded
nature of this. What prevents the log from being flooded with
temperature warnings?

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
