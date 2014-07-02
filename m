Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaGBPay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:30:54 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:37148 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaGBPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:30:52 -0400
Message-ID: <53B425A3.9090404@acm.org>
Date: Wed, 02 Jul 2014 17:30:43 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Paul Mackerras <paulus@samba.org>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
References: <20140630103058.GA17747@iris.ozlabs.ibm.com> <20140701193907.GA15306@redhat.com>
In-Reply-To: <20140701193907.GA15306@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 21:39, Mike Snitzer wrote:
> (btw, Bart Van Assche also has issues with commit e8099177 due to hangs
> during cable pull testing of mpath devices -- Bart: curious to know if
> your cable pull tests pass if you just revert bcccff93).

Sorry but even with bcccff93 reverted after a few iterations my cable
pull simulation test still causes several tasks to hang in sleep_on_page().

Bart.

