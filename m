Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaGVBYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:24:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaGVBYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:24:00 -0400
Date: Tue, 22 Jul 2014 02:23:52 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
	in copy_params
Message-ID: <20140722012352.GD6822@agk-dp.fab.redhat.com>
Mail-Followup-To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	"Liu, ShuoX" <shuox.liu@intel.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CDB81B.90509@linux.intel.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 2014/7/9 6:39, Mikulas Patocka wrote:
>> Which ioctl with more than 16kB
>> arguments do you use? 

Unanswered.  Let's ask the same question in a different way:

Please supply the output of these three commands on the real-world system on
which you believe that that particular allocation is causing you a problem:
  dmsetup info -c
  dmsetup table
  dmsetup status

Alasdair

