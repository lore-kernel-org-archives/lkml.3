Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaCNUhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:37:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22853 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaCNUho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:37:44 -0400
To: "Reddy\, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: <jejb@kernel.org>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <linux-kernel@vger.kernel.org>,
        <sreekanthreddy0547@gmail.com>
Subject: Re: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter disable_eedp to Disable EEDP Support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140314153622.GA7947@lsi.com>
Date: Fri, 14 Mar 2014 16:37:27 -0400
In-Reply-To: <20140314153622.GA7947@lsi.com> (Sreekanth Reddy's message of
	"Fri, 14 Mar 2014 21:06:22 +0530")
Message-ID: <yq1r464wm7s.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@lsi.com> writes:

Sreekanth> A new mpt2sas driver module parameter 'disable_eedp' is added
Sreekanth> to Disable EEDP support. By default DIF support is enabled in
Sreekanth> the driver and this module parameter would allow users to
Sreekanth> turn it off.

Why don't you just set the prot_mask module parameter to 0?

-- 
Martin K. Petersen	Oracle Linux Engineering
