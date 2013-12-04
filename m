Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3LDEnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:43:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab3LDEnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:43:17 -0500
Date: Tue, 3 Dec 2013 23:43:06 -0500
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: Re: sysfs: use a separate locking class for open files depending on
 mmap
Message-ID: <20131204044306.GA13248@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org
References: <20131128051223.45739660885@gitolite.kernel.org>
 <20131203184324.GA11320@redhat.com>
 <20131203211028.GN8277@htj.dyndns.org>
 <20131203211515.GA17951@redhat.com>
 <20131203213649.GO8277@htj.dyndns.org>
 <20131203221543.GP8277@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203221543.GP8277@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:15:43PM -0500, Tejun Heo wrote:
 > Hello,
 > 
 > Can you please test whether this patch makes the lockdep warning go
 > away?
 > 
 > Thanks a lot!
 
been running a few hours now, looks good.

Tested-by: Dave Jones <davej@fedoraproject.org>

	Dave

