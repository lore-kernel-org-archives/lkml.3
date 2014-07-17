Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaGQQiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:38:03 -0400
Received: from wolff.to ([98.103.208.27]:53367 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756898AbaGQQiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:38:01 -0400
Date: Thu, 17 Jul 2014 11:36:27 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140717163627.GA2489@wolff.to>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
 <20140717030947.GA17889@wolff.to>
 <53C79013.1020808@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <53C79013.1020808@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did a few quick boots this morning while taking a bunch of pictures. I have 
gone through some of them this morning and found one that shows bug on 
was triggered at 5850 which is from:
BUG_ON(!cpumask_empty(sched_group_cpus(sg)));

You can see the JPEG at:
https://bugzilla.kernel.org/attachment.cgi?id=143331
