Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3LETw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:52:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab3LETwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:52:25 -0500
Date: Thu, 5 Dec 2013 14:52:12 -0500
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH driver-core-linus] sysfs: give different locking key to
 regular and bin files
Message-ID: <20131205195212.GA14125@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131203184324.GA11320@redhat.com>
 <20131203211028.GN8277@htj.dyndns.org>
 <20131203211515.GA17951@redhat.com>
 <20131203213649.GO8277@htj.dyndns.org>
 <20131203221543.GP8277@htj.dyndns.org>
 <20131204044306.GA13248@redhat.com>
 <20131204140639.GI3158@htj.dyndns.org>
 <20131204141345.GJ3158@htj.dyndns.org>
 <20131204142040.GK3158@htj.dyndns.org>
 <20131205194440.GA13889@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205194440.GA13889@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 11:44:40AM -0800, Greg KH wrote:
 > On Wed, Dec 04, 2013 at 09:20:40AM -0500, Tejun Heo wrote:
 > > Dave, can you please test this one too?  Greg, once this turns out to
 > > be okay, I'll send you a merged branch which pulls in
 > > driver-core-linus + this patch into driver-core-next which will surely
 > > generate conflict.
 > 
 > Dave, did this patch fix the issue?
 
I hit some unrelated issues instead, so I'd say 'probably'.
Given I could quickly hit it before, I'd say it works.

	Dave

