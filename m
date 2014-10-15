Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaJOBHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 21:07:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41966 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaJOBG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 21:06:59 -0400
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141010074901.GA32028@sucs.org>
Date: Tue, 14 Oct 2014 21:06:37 -0400
In-Reply-To: <20141010074901.GA32028@sucs.org> (Sitsofe Wheeler's message of
	"Fri, 10 Oct 2014 08:49:01 +0100")
Message-ID: <yq1r3ya6t0i.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> A previous patch attempted to add a quirk to workaround this
Sitsofe> but the quirk was only enabled after the features had been
Sitsofe> scanned for, wouldn't work for "small" disks 

What does that mean, exactly?

-- 
Martin K. Petersen	Oracle Linux Engineering
