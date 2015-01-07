Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbbAGXmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:42:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50325 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbbAGXmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:42:42 -0500
To: "Sam Bradshaw \(sbradshaw\)" <sbradshaw@micron.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "axboe\@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: pass correct seed to integrity metadata generation function
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <54936D1E.3020700@micron.com> <54ADBC6E.50301@micron.com>
	<yq14ms25g21.fsf@sermon.lab.mkp.net>
	<80B89753B40C5141A3E2D53FE7A2A8A994634D2A@NTXBOIMBX02.micron.com>
Date: Wed, 07 Jan 2015 18:42:35 -0500
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A994634D2A@NTXBOIMBX02.micron.com>
	(Sam Bradshaw's message of "Wed, 7 Jan 2015 23:30:05 +0000")
Message-ID: <yq1r3v640pg.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sam" == Sam Bradshaw (sbradshaw) <sbradshaw@micron.com> writes:

Sam> Yes, you were CC: on the original.  Could you take a peek at the
Sam> patch and give me feedback?  https://lkml.org/lkml/2014/12/18/521

Is the target an NVMe device?

-- 
Martin K. Petersen	Oracle Linux Engineering
